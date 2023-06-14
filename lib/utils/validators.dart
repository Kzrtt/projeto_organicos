import 'package:intl/intl.dart';

class Validators {
  String? precoValidate(String? preco) {
    int precoInt = int.parse(preco!);
    if (precoInt < 0) {
      return "O valor deve ser maior que 0";
    } else if (preco == "") {
      return "O campo deve ser preenchido";
    }
  }

  String? birthDateValidator(String? birthDate) {
    // Converte a data de nascimento de String para DateTime
    if (birthDate == "") {
      return null;
    }
    final inputFormat = DateFormat("dd/MM/yyyy");
    DateTime dateOfBirth = inputFormat.parse(birthDate!);

    final outputFormat = DateFormat("yyyy-MM-dd");
    final outputDate = outputFormat.format(dateOfBirth);
    dateOfBirth = DateTime.parse(outputDate);

    // Calcula a idade com base na data de nascimento
    final age = DateTime.now().difference(dateOfBirth).inDays ~/ 365;

    // Verifica se a idade é menor que 18 anos
    if (age < 18) {
      return 'É necessário ser maior de idade';
    }

    // Maior de idade
    return null;
  }

  String? nameValidator2(String? name) {
    if (name == "") {
      return null;
    }
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(name!)) {
      return "Somente letras são permitidas neste campo";
    }
    return null;
  }

  String? phoneValidator2(String? phone) {
    if (phone == "") {
      return null;
    }
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(phone!)) {
      return "Somente letras são permitidas neste campo";
    }
    return null;
  }

  String? cpfValidate2(String? cpf) {
    if (cpf == "") {
      return null;
    }
    if (!RegExp(r'^[a-zA-Z0-9]').hasMatch(cpf!)) {
      return "Não são permitidos caracteres especiais";
    }
    // Remove caracteres especiais do CPF
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    // Verifica se o CPF possui 11 dígitos
    if (cpf.length != 11) {
      return 'CPF inválido';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Calcula o primeiro dígito verificador
    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    var digit1 = 11 - (sum % 11);
    if (digit1 > 9) {
      digit1 = 0;
    }

    // Calcula o segundo dígito verificador
    sum = 0;
    for (var i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    var digit2 = 11 - (sum % 11);
    if (digit2 > 9) {
      digit2 = 0;
    }

    // Verifica se os dígitos verificadores estão corretos
    if (digit1.toString() != cpf[9] || digit2.toString() != cpf[10]) {
      return 'CPF inválido';
    }
    return null;
  }

  String? nameValidator(String? name) {
    if (name == "") {
      return "Por favor, insira seu nome";
    } else if (name!.length < 3) {
      return "O nome deve conter mais que 3 letras";
    } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(name)) {
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
    // Remove caracteres especiais do CPF
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    // Verifica se o CPF possui 11 dígitos
    if (cpf.length != 11) {
      return 'CPF inválido';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Calcula o primeiro dígito verificador
    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    var digit1 = 11 - (sum % 11);
    if (digit1 > 9) {
      digit1 = 0;
    }

    // Calcula o segundo dígito verificador
    sum = 0;
    for (var i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    var digit2 = 11 - (sum % 11);
    if (digit2 > 9) {
      digit2 = 0;
    }

    // Verifica se os dígitos verificadores estão corretos
    if (digit1.toString() != cpf[9] || digit2.toString() != cpf[10]) {
      return 'CPF inválido';
    }
    return null;
  }

  String? phoneValidator(String? phone) {
    if (phone == "") {
      return "Por favor, insira seu telefone";
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == "") {
      return "Por favor, insira sua senha";
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~._-]).{8,}$')
        .hasMatch(password!)) {
      return 'A senha deve conter pelo menos uma letra\nmaiúscula, uma letra minúscula, um número\ne um caractere especial';
    }
    return null;
  }

  String? cepValidator(String? cep) {
    // Remove caracteres especiais do CEP
    cep = cep!.replaceAll(RegExp(r'[^\d]'), '');

    // Verifica se o CEP possui 8 dígitos
    if (cep.length != 8) {
      return 'CEP inválido';
    }

    // CEP válido
    return null;
  }

  String? cpnjValidator(String? cnpj) {
    if (cnpj == "") {
      return "Por favor, insira sua senha";
    }
    // Remove caracteres especiais do CNPJ
    cnpj = cnpj?.replaceAll(RegExp(r'[^\d]'), '');

    // Verifica se o CNPJ possui 14 dígitos
    if (cnpj!.length != 14) {
      return 'CNPJ inválido';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) {
      return 'CNPJ inválido';
    }

    // Calcula o primeiro dígito verificador
    var sum = 0;
    var weights = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    for (var i = 0; i < 12; i++) {
      sum += int.parse(cnpj[i]) * weights[i];
    }
    var digit1 = sum % 11 < 2 ? 0 : 11 - (sum % 11);

    // Calcula o segundo dígito verificador
    sum = 0;
    weights.insert(0, 6);
    for (var i = 0; i < 13; i++) {
      sum += int.parse(cnpj[i]) * weights[i];
    }
    var digit2 = sum % 11 < 2 ? 0 : 11 - (sum % 11);

    // Verifica se os dígitos verificadores estão corretos
    if (digit1.toString() != cnpj[12] || digit2.toString() != cnpj[13]) {
      return 'CNPJ inválido';
    }

    // CNPJ válido
    return null;
  }

  String? adressValidator(String? adress) {
    if (adress == "") {
      return "Por favor, insira um endereço válido";
    }
    return null;
  }
}
