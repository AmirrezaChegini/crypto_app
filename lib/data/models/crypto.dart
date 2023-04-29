class Crypto {
  int _id;
  int _rank;
  String _name;
  String _symbol;
  double _price;
  double _percentChange;
  String _image;

  Crypto(
    this._id,
    this._rank,
    this._name,
    this._symbol,
    this._price,
    this._percentChange,
    this._image,
  );

  factory Crypto.fromMapJson(Map<String, dynamic> jsonObject) {
    return Crypto(
      jsonObject['id'],
      jsonObject['cmcRank'],
      jsonObject['name'],
      jsonObject['symbol'],
      jsonObject['quotes'][0]['price'],
      jsonObject['quotes'][0]['percentChange24h'],
      'https://s2.coinmarketcap.com/static/img/coins/64x64/${jsonObject['id']}.png',
    );
  }

  int get id => _id;
  int get rank => _rank;
  String get name => _name;
  String get symbol => _symbol;
  double get price => _price;
  double get percentChange => _percentChange;
  String get image => _image;
}
