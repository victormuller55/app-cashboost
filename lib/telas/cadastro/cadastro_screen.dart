import 'package:app_cashback_soamer/app_widget/colors.dart';
import 'package:app_cashback_soamer/app_widget/formatters/formatter.dart';
import 'package:app_cashback_soamer/app_widget/snack_bar/snack_bar.dart';
import 'package:app_cashback_soamer/app_widget/strings.dart';
import 'package:app_cashback_soamer/app_widget/validators/validators.dart';
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
  TextEditingController controllerCPF = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerConfirmarSenha = TextEditingController();

  bool termosAceitos = false;

  void _salvar() {
    UsuarioModel usuarioModel = UsuarioModel(
      nomeUsuario: controllerNome.text,
      emailUsuario: controllerEmail.text,
      cpfUsuario: controllerCPF.text.replaceAll(".", "").replaceAll("-", ""),
      senhaUsuario: controllerSenha.text,
    );

    cadastroBloc.add(CadastroSalvarEvent(usuarioModel));
  }

  void _validar() {
    if (verificaCampoVazio(controllers: [controllerNome.text, controllerEmail.text, controllerCPF.text, controllerSenha.text, controllerConfirmarSenha.text])) {
      if (emailValido(controllerEmail.text)) {
        if (cpfValido(controllerCPF.text)) {
          if (controllerSenha.text == controllerConfirmarSenha.text) {
            if (termosAceitos) {
              _salvar();
            } else {
              showSnackbarWarning(context, message: Strings.concordeComOsTermosDeUsoEPoliticaDePrivacidade);
            }
          } else {
            showSnackbarWarning(context, message: Strings.asSenhasNaoSaoIguais);
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
    }
    _focusScope.unfocus();
  }

  Widget _body() {
    return FocusScope(
      node: _focusScope,
      child: Column(
        children: [
          sizedBoxVertical(70),
          formFieldPadrao(context, controller: controllerNome, Strings.nome, width: 300, textInputType: TextInputType.name),
          formFieldPadrao(context, controller: controllerEmail, Strings.email, width: 300, textInputType: TextInputType.emailAddress),
          formFieldPadrao(context, controller: controllerCPF, Strings.cpf, width: 300, textInputType: TextInputType.number, textInputFormatter: FormattersSoamer.cpfFormatter),
          formFieldPadrao(context, controller: controllerSenha, Strings.senha, width: 300, showSenha: false, textInputType: TextInputType.visiblePassword),
          formFieldPadrao(context, controller: controllerConfirmarSenha, Strings.confirmarSenha, width: 300, showSenha: false, textInputType: TextInputType.visiblePassword),
          sizedBoxVertical(20),
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
          sizedBoxVertical(20),
          _botaoCadastrarBloc(),
          sizedBoxVertical(10),
          elevatedButtonText(
            Strings.jaTenhoConta.toUpperCase(),
            transparente: true,
            function: () => open(context, screen: const EntrarScreen(), closePrevious: true),
          ),
          sizedBoxVertical(20),
        ],
      ),
    );
  }

  Widget _botaoCadastrarBloc() {
    return BlocConsumer<CadastroBloc, CadastroState>(
      bloc: cadastroBloc,
      listener: (context, state) => _onChangeState(state),
      builder: (context, state) => elevatedButtonPadrao(
        function: () => _validar(),
        state is CadastroLoadingState
            ? const CircularProgressIndicator()
            : text(
                Strings.cadastrar.toUpperCase(),
                color: AppColor.primaryColor,
                bold: true
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: backgroundCadastroLogin(context, child: _body()));
  }
}
