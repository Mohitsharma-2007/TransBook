class IndianAmountWords {
  static final List<String> _ones = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
    'Seventeen', 'Eighteen', 'Nineteen'
  ];

  static final List<String> _tens = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
  ];

  static String convert(double amount) {
    if (amount == 0.0) return 'Rupees Zero Only';

    int rupees = amount.floor();
    int paise = ((amount - rupees) * 100).round();

    String result = 'Rupees ${_convertNumber(rupees)}';

    if (paise > 0) {
      result += ' and Paise ${_convertNumber(paise)}';
    }

    result += ' Only';

    return result.replaceAll('  ', ' ').trim();
  }

  static String _convertNumber(int number) {
    if (number == 0) return 'Zero';

    String result = "";

    if ((number ~/ 10000000) > 0) {
      result += "${_convertNumber(number ~/ 10000000)} Crore ";
      number %= 10000000;
    }

    if ((number ~/ 100000) > 0) {
      result += "${_convertNumber(number ~/ 100000)} Lakh ";
      number %= 100000;
    }

    if ((number ~/ 1000) > 0) {
      result += "${_convertNumber(number ~/ 1000)} Thousand ";
      number %= 1000;
    }

    if ((number ~/ 100) > 0) {
      result += "${_convertNumber(number ~/ 100)} Hundred ";
      number %= 100;
    }

    if (number > 0) {
      if (number < 20) {
        result += _ones[number];
      } else {
        result += _tens[number ~/ 10];
        if ((number % 10) > 0) {
          result += " ${_ones[number % 10]}";
        }
      }
    }

    return result.trim();
  }
}
