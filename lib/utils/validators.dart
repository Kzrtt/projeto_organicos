class Validators {
  String? nameValidator(String? name) {
    if (name == "") {
      return "Por favor, insira seu nome";
    } else if (name!.length < 3) {
      return "Por favor, insira seu nome";
    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(name)) {
      return "Somente letras são permitidas neste campo";
    }
    return null;
  }

  String? emailValidator(String? email) {
    if (email! == "") {
      return "Por favor, insira seu email";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return "Insira um email válido";
    }
    return null;
  }

  String? cpfValidate(String? cpf) {
    if (cpf == "") {
      return "Por favor, insira seu cpf";
    } else if (!RegExp(r'^[a-zA-Z0-9]').hasMatch(cpf!)) {
      return "Não são permitidos caracteres especiais";
    }
    return null;
  }

  String? phoneValidator(String? phone) {
    if (phone == "") {
      return "Por favor, insira seu telefone";
    } else if (!RegExp(r'^[0-9]').hasMatch(phone!)) {
      return "Somente numeros são permitidos neste campo";
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == "") {
      return "Por favor, insira sua senha";
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password!)) {
      return 'A senha deve conter pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial';
    }
    return null;
  }
}
