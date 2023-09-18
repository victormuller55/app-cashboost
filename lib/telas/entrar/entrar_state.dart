import 'package:app_cashback_soamer/models/error_model.dart';
import 'package:app_cashback_soamer/models/usuario_model.dart';

abstract class EntrarState {
  ErrorModel errorModel;
  UsuarioModel usuarioModel;

  EntrarState({required this.usuarioModel, required this.errorModel});
}

class EntrarInitialState extends EntrarState {
  EntrarInitialState({required UsuarioModel contaModel, required ErrorModel errorModel}) : super(usuarioModel: contaModel, errorModel: errorModel);
}

class EntrarLoadingState extends EntrarState {
  EntrarLoadingState({required UsuarioModel contaModel, required ErrorModel errorModel}) : super(usuarioModel: contaModel, errorModel: errorModel);
}

class EntrarSuccessState extends EntrarState {
  EntrarSuccessState({required UsuarioModel usuarioModel, required ErrorModel errorModel}) : super(usuarioModel: usuarioModel, errorModel: errorModel);
}

class EntrarErrorState extends EntrarState {
  EntrarErrorState({required UsuarioModel contaModel, required ErrorModel errorModel}) : super(usuarioModel: contaModel, errorModel: errorModel);
}
