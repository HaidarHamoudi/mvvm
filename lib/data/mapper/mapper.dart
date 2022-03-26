// to convert the response into a non nullable object (model)

import 'package:mvvm/app/extensions.dart';

import '../../domain/model/model.dart';
import '../responses/responses.dart';

const EMPTY = "";
const ZERO = 0;
const ZERO_DOUBLE = 0.0;
const BOOLEAN_FALSE = false;

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
      this?.id?.orEmpty() ?? EMPTY,
      this?.name?.orEmpty() ?? EMPTY,
      this?.numOfNotifications?.orZero() ?? ZERO,
    );
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
      this?.email?.orEmpty() ?? EMPTY,
      this?.phone?.orEmpty() ?? EMPTY,
      this?.link?.orEmpty() ?? EMPTY,
    );
  }
}

// here we convert the customer response to a customer object (using toDomain)
extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(
      this?.customer.toDomain(),
      this?.contacts.toDomain(),
    );
  }
}

// here we convert the forget password response to a forget password object (using toDomain)
extension ForgetPasswordResponseMapper on ForgetPasswordResponse? {
  String toDomain() {
    return this?.support?.orEmpty() ?? EMPTY;
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(
      this?.id.orZero() ?? ZERO,
      this?.title.orEmpty() ?? EMPTY,
      this?.image.orEmpty() ?? EMPTY,
    );
  }
}

extension StoreResponseMapper on StoreResponse? {
  Store toDomain() {
    return Store(
      this?.id.orZero() ?? ZERO,
      this?.title.orEmpty() ?? EMPTY,
      this?.image.orEmpty() ?? EMPTY,
    );
  }
}

extension BannerResponseMapper on BannerResponse? {
  BannerAd toDomain() {
    return BannerAd(
      this?.id.orZero() ?? ZERO,
      this?.title.orEmpty() ?? EMPTY,
      this?.image.orEmpty() ?? EMPTY,
      this?.link.orEmpty() ?? EMPTY,
    );
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Service> mappedService =
        (this?.data?.services?.map((service) => service.toDomain()) ??
                Iterable.empty())
            .cast<Service>()
            .toList();
    List<Store> mappedStores =
        (this?.data?.stores?.map((store) => store.toDomain()) ??
                Iterable.empty())
            .cast<Store>()
            .toList();
    List<BannerAd> mappedBanners =
        (this?.data?.banners?.map((bannerAd) => bannerAd.toDomain()) ??
                Iterable.empty())
            .cast<BannerAd>()
            .toList();

    HomeData data = HomeData(mappedService, mappedStores, mappedBanners);
    return HomeObject(data);
  }
}
