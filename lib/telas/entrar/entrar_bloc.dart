import 'dart:convert';
import 'package:app_cashback_soamer/functions/local_data.dart';
import 'package:app_cashback_soamer/models/vendedor_model.dart';
import 'package:app_cashback_soamer/telas/entrar/entrar_event.dart';
import 'package:app_cashback_soamer/telas/entrar/entrar_service.dart';
import 'package:app_cashback_soamer/telas/entrar/entrar_state.dart';
import 'package:app_cashback_soamer/telas/home/home_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:muller_package/muller_package.dart';

class EntrarBloc extends Bloc<EntrarEvent, EntrarState> {
  EntrarBloc() : super(EntrarInitialState()) {
    on<EntrarLoginEvent>((event, emit) async {
      emit(EntrarLoadingState());
      try {

        AppResponse response = await getUser(event.email, event.senha);
        VendedorModel vendedorModel = VendedorModel.fromMap(jsonDecode(response.body));
        saveLocalUserData(vendedorModel);

        open(screen: HomeScreen(vendedorModel: state.vendedorModel), closePrevious: true);

        emit(EntrarSuccessState(vendedorModel:vendedorModel));

        if (vendedorModel.nomeConcessionaria != null || vendedorModel.nomeConcessionaria != "") {
          addLocalDataString("nome_concessionaria", vendedorModel.nomeConcessionaria ?? "");
        }
      } catch (e) {
        emit(EntrarErrorState(errorModel: ApiException.errorModel(e)));
        showSnackbarError(message: state.errorModel.mensagem);
      }
    });
  }
}
