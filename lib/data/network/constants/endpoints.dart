class Endpoints {
  Endpoints._();

  // base url
  static const baseUrlStatistics = "https://api.covid19api.com";

  // base url to retreieve user's IP
  static const baseUrlIP = "https://httpbin.org/ip";

  // base url to retrive iso2 code based on IP
  static const baseUrlCurrentCountry = 'https://freegeoip.live/json';

  // base url to retrieve country flags
  static const baseUrlCountryFlags = 'https://www.countryflags.io/';

  static const preventionDataSourceReferenceURL =
      'https://visme.co/blog/coronavirus-prevention';

  static const preventionDataSourceAuthorURL = 'https://www.chloesocial.com';

  static const informationDataSourceReferenceURL =
      'https://visme.co/blog/what-is-coronavirus';

  static const informationSourceAuthorURL = 'https://www.mahnoorsheikh.com';

  // receiveTimeout
  static const receiveTimeout = 5000;

  // connectTimeout
  static const connectionTimeout = 3000;

  // fetch Home Data (Global and Countries Summary)
  static const _fetchHomeData = '/summary';

  // fetch Statistics about a particulr country
  static const _fetchCountryStatistics = '/total/country/';

  static String get fetchIP => baseUrlIP;

  static String get fetchCurrentCountry => baseUrlCurrentCountry;

  static String get fetchHomeData => baseUrlStatistics + _fetchHomeData;

  static String get fetchCountryStatistics =>
      baseUrlStatistics + _fetchCountryStatistics;
}
