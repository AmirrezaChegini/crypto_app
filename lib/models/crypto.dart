class Crypto {
  int _id;
  String _name;
  String _symbol;
  double _price;
  double _highPrice;
  double _lowPrice;
  double _marketCap;
  double _percentChange24;

  Crypto(
    this._id,
    this._name,
    this._symbol,
    this._price,
    this._highPrice,
    this._lowPrice,
    this._marketCap,
    this._percentChange24,
  );

  factory Crypto.fromMapJson(Map<String, dynamic> jsonObject) {
    return Crypto(
      jsonObject['id'],
      jsonObject['name'],
      jsonObject['symbol'],
      jsonObject['quotes'][0]['price'],
      jsonObject['high24h'],
      jsonObject['low24h'],
      jsonObject['quotes'][0]['marketCap'],
      jsonObject['quotes'][0]['percentChange24h'],
    );
  }

  int get id => _id;
  String get name => _name;
  String get symbol => _symbol;
  double get price => _price;
  double get highPrice => _highPrice;
  double get lowPrice => _lowPrice;
  double get marketCap => _marketCap;
  double get percentChange24 => _percentChange24;
}
