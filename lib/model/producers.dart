class Producers {
  final int producerId;
  final String producerName;
  final String producerCpf;
  final String producerEmail;
  final String password;
  final bool isFromCooperative;

  Producers({
    required this.producerId,
    required this.producerName,
    required this.producerEmail,
    required this.producerCpf,
    required this.password,
    required this.isFromCooperative,
  });
}
