class FamilyMember {
  FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
    this.dob = '',
    this.allergies = 'None',
  });

  final String id;
  String name;
  String relationship;
  String phone;
  String dob;
  String allergies;

  static const relationships = [
    'Spouse', 'Child', 'Parent', 'Sibling',
    'Grandparent', 'Guardian', 'Other',
  ];
}
