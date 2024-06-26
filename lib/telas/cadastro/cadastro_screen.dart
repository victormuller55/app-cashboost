import 'package:app_cashback_soamer/app_widget/colors.dart';
import 'package:app_cashback_soamer/app_widget/form_field_formatters/form_field_formatter.dart';
import 'package:app_cashback_soamer/app_widget/snack_bar/snack_bar.dart';
import 'package:app_cashback_soamer/app_widget/strings.dart';
import 'package:app_cashback_soamer/app_widget/validators/validators.dart';
import 'package:app_cashback_soamer/functions/formatters.dart';
import 'package:app_cashback_soamer/functions/local_data.dart';
import 'package:app_cashback_soamer/functions/navigation.dart';
import 'package:app_cashback_soamer/functions/util.dart';
import 'package:app_cashback_soamer/models/usuario_model.dart';
import 'package:app_cashback_soamer/telas/apresentacao/apresentacao_screen.dart';
import 'package:app_cashback_soamer/telas/cadastro/cadastro_bloc.dart';
import 'package:app_cashback_soamer/telas/cadastro/cadastro_event.dart';
import 'package:app_cashback_soamer/telas/cadastro/cadastro_state.dart';
import 'package:app_cashback_soamer/telas/entrar/entrar_screen.dart';
import 'package:app_cashback_soamer/widgets/elevated_button.dart';
import 'package:app_cashback_soamer/widgets/form_field.dart';
import 'package:app_cashback_soamer/widgets/sized_box.dart';
import 'package:app_cashback_soamer/widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  CadastroBloc cadastroBloc = CadastroBloc();
  final FocusScopeNode _focusScope = FocusScopeNode();

  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerCelular = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();

  bool termosAceitos = false;

  void _salvar() {
    UsuarioModel usuarioModel = UsuarioModel(
      nomeUsuario: controllerNome.text,
      emailUsuario: controllerEmail.text,
      celularUsuario: somenteNumeros(controllerCelular.text),
      cpfUsuario: controllerCPF.text.replaceAll(".", "").replaceAll("-", ""),
      senhaUsuario: controllerSenha.text,
    );

    cadastroBloc.add(CadastroSalvarEvent(usuarioModel));
  }

  void _validar() {
    if (verificaCampoVazio(controllers: [controllerNome.text, controllerEmail.text, controllerCPF.text, controllerSenha.text])) {
      if (emailValido(controllerEmail.text)) {
        if (cpfValido(controllerCPF.text)) {
          if (termosAceitos) {
            _salvar();
          } else {
            showSnackbarWarning(context, message: Strings.concordeComOsTermosDeUsoEPoliticaDePrivacidade);
          }
        } else {
          showSnackbarWarning(context, message: Strings.cpfInvalido);
        }
      } else {
        showSnackbarWarning(context, message: Strings.emailInvalido);
      }
    } else {
      showSnackbarWarning(context, message: Strings.todosOsCamposSaoObrigatorios);
    }
  }

  void _onChangeState(CadastroState state) {
    if (state is CadastroErrorState) showSnackbarError(context, message: state.errorModel.mensagem!.isEmpty ? "Ocorreu um erro, tente novamente mais tarde." : state.errorModel.mensagem);
    if (state is CadastroSuccessState) {
      open(context, screen: ApresentacaoScreen(usuarioModel: state.usuarioModel), closePrevious: true);
      saveLocalUserData(state.usuarioModel);
      if (state.usuarioModel.nomeConcessionaria != null || state.usuarioModel.nomeConcessionaria != "") addLocalDataString("nome_concessionaria", state.usuarioModel.nomeConcessionaria ?? "");
    }
    _focusScope.unfocus();
  }

  Widget _body() {
    return FocusScope(
      node: _focusScope,
      child: Column(
        children: [
          appSizedBoxHeight(70),
          formFieldPadrao(context, controller: controllerNome, "Nome", width: 300, textInputType: TextInputType.name),
          appSizedBoxHeight(10),
          formFieldPadrao(context, controller: controllerEmail, "E-mail", width: 300, textInputType: TextInputType.emailAddress),
          appSizedBoxHeight(10),
          formFieldPadrao(context, controller: controllerCelular, "Celular", width: 300, textInputType: TextInputType.number, textInputFormatter: FormFieldFormatter.celularFormatter),
          appSizedBoxHeight(10),
          formFieldPadrao(context, controller: controllerCPF, "CPF", width: 300, textInputType: TextInputType.number, textInputFormatter: FormFieldFormatter.cpfFormatter),
          appSizedBoxHeight(10),
          formFieldPadrao(context, controller: controllerSenha, "Senha", width: 300, showSenha: false, textInputType: TextInputType.visiblePassword),
          appSizedBoxHeight(20),
          SizedBox(
            width: 330,
            child: CheckboxListTile(
              value: termosAceitos,
              title: text(Strings.concordoTermosPoliticas, color: Colors.white, bold: false),
              onChanged: (value) => setState(() => termosAceitos = !termosAceitos),
              checkColor: AppColor.primaryColor,
              fillColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
          appSizedBoxHeight(20),
          elevatedButtonPadrao(
            function: () => _validar(),
            text(Strings.cadastrar.toUpperCase(), color: AppColor.primaryColor, bold: true, fontSize: 12),
          ),
          appSizedBoxHeight(10),
          elevatedButtonText(
            Strings.jaTenhoConta.toUpperCase(),
            color: AppColor.primaryColor.withOpacity(0.5),
            textColor: Colors.white,
            function: () => open(context, screen: const EntrarScreen(), closePrevious: true),
          ),
          appSizedBoxHeight(20),
        ],
      ),
    );
  }

  Widget _bodyBuilder() {
    return BlocConsumer<CadastroBloc, CadastroState>(
      bloc: cadastroBloc,
      listener: (context, state) => _onChangeState(state),
      builder: (context, state) {
        switch (state.runtimeType) {
          case CadastroLoadingState:
            return loading(color: Colors.white);
          default:
            return _body();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backgroundCadastroLogin(
        context,
        child: _bodyBuilder(),
      ),
    );
  }
}
