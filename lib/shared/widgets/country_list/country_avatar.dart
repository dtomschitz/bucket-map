part of shared.widgets;

class CountryAvatar extends StatelessWidget {
  CountryAvatar(String code) : this.code = code?.toLowerCase();
  final String code;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: code == null
          ? null
          : NetworkImage('https://flagcdn.com/w160/$code.png'),
      backgroundColor: Colors.grey.shade300,
    );
  }
}
