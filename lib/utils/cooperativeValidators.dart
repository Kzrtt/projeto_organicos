class CooperativeValidators {
  String? nameValidator(String? string) {
    if (string == "") {
      return "Por favor, insira o nome da Cooperativa";
    } else if (string!.length <= 3) {
      return "O nome deve conter mais que 3 letras";
    } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(string)) {
      return "Somente letras são permitidas nesse campo";
    }
    return null;
  }

  String? emailValidator(String? string) {
    if (string == "") {
      return "Por favor, insira seu email";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(string!)) {
      return "Por favor, insira um email válido";
    }
    return null;
  }

  String? phoneValidator(String? string) {
    if (string == "") {
      return "Por favor, insira seu telefone";
    }
    return null;
  }

  String? cnpjValidate(String? string) {
    if (string == "") {
      return "Por favor, insira seu cnpj";
    } else if (!RegExp(r'^[a-zA-Z0-9]').hasMatch(string!)) {
      return "Não são permitidos caracteres especiais";
    }
    return null;
  }

  String? passwordValidator(String? string) {
    if (string == "") {
      return "Por favor, insira sua senha";
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(string!)) {
      return 'A senha deve conter pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial';
    }
    return null;
  }

  String? adressValidation(String? string) {
    if (string == "") {
      return "Por favor, insira algo";
    }
    return null;
  }
}
