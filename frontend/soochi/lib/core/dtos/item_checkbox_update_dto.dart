class ItemCheckboxUpdateDTO {
  final bool isChecked;

  ItemCheckboxUpdateDTO({
    required this.isChecked,
  });

  factory ItemCheckboxUpdateDTO.fromJson(Map<String, dynamic> json) {
    return ItemCheckboxUpdateDTO(
      isChecked: json['isChecked'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'isChecked': isChecked,
    };
  }
}