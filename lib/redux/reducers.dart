import 'package:g_p/models/app_state.dart';
import 'package:g_p/models/order.dart';
import 'package:g_p/models/product.dart';
import 'package:g_p/models/user.dart';
import 'package:g_p/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(user: userReducer(state.user, action),
  products: productsReducer(state.products, action),
  carproducts: CarProductsReducer(state.carproducts, action),
  wedproducts: WedProductsReducer(state.wedproducts, action),
  eleproducts: EleProductsReducer(state.eleproducts, action),
  lthproducts: LthProductsReducer(state.lthproducts, action),
  htlproducts: HtlProductsReducer(state.htlproducts, action),
  cartProducts: cartProducts(state.cartProducts, action),
  cards: cardsReducer(state.cards, action),
  orders: ordersReducer(state.orders, action));

}

User? userReducer( user, action) {
  if (action is GetUserAction) {
    return action.user;
  }else if (action is LogoutUserAction) {
    return action.user;
  }
  return user;
}

 productsReducer( products, action) {
  if (action is GetProductsAction) {
    return action.products;
  }
  return products;
}

WedProductsReducer( wedproducts, action) {
  if (action is GetWedProductsAction) {
    return action.wedproducts;
  }
  return wedproducts;
}

EleProductsReducer( eleproducts, action) {
  if (action is GetEleProductsAction) {
    return action.eleproducts;
  }
  return eleproducts;
}

LthProductsReducer( lthproducts, action) {
  if (action is GetLthProductsAction) {
    return action.lthproducts;
  }
  return lthproducts;
}
HtlProductsReducer( htlproducts, action) {
  if (action is GetHtlProductsAction) {
    return action.htlproducts;
  }
  return htlproducts;
}

CarProductsReducer( carproducts, action) {
  if (action is GetCarProductsAction) {
    return action.carproducts;
  }
  return carproducts;
}

 cartProducts( cartProducts, action) {

   if (action is GetCartProductsAction) {
     return action.cartProducts;
   }
  else if (action is ToggleCartProductAction) {
    return action.cartProducts;
  } else if (action is ClearCartProductsAction) {
return action.cartProducts;
}

return cartProducts;
}

cardsReducer( cards, dynamic action) {
  if (action is GetCardsAction) {
    return action.cards;
  }
  return cards;
}
List<Order> ordersReducer( orders, dynamic action) {
  if (action is GetOrdersAction) {
    return action.orders;
  } else if (action is AddOrderAction) {
    return List.from(orders)..add(action.order);
  }
  return orders;
}
