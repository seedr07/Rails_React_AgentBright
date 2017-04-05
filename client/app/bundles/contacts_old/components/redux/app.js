import request from 'axios';
import { AWAIT_MARKER } from 'redux-await';
export const FETCH_CONTACTS = 'patrick/fetchContacts';

// export const SESSION = 'costimize/src/redux/modules/session/SESSION'
// export const IS_GUEST = 'costimize/src/redux/modules/session/IS_GUEST'
// export const STORE_SESSION = 'costimize/src/redux/modules/session/STORE_SESSION'
// export const CLEAR_SESSION = 'costimize/src/redux/modules/session/CLEAR_SESSION'

const initialState = {
  contacts: [],
};

export function reducer(state = initialState, action) {
  switch (action.type) {
    case FETCH_CONTACTS:
      return {
        ...state,
        contacts: action.payload[action.type].data.contacts,
      };

//     case CLEAR_SESSION:
//       return {
//         ...initialState,
//         guest: true
//       }
//     case LOGIN:
//       return {
//         ...state,
//         ...action.payload[action.type]
//       }
//     case STORE_SESSION: {
//       const { user, entities, token, subscription } = action.payload.data
//       return {
//         ...state,
//         user,
//         entities,
//         entity: entities.length && entities[0],
//         token,
//         subscription
//       }
//     }
//     case IS_GUEST:
//       return {
//         ...state,
//         guest: action.payload
//       }
    default:
      return state;
  }
}

export function fetchContacts() {
  return {
    type: FETCH_CONTACTS,
    AWAIT_MARKER,
    payload: {
      [FETCH_CONTACTS]: request.get('contacts.json', { responseType: 'json' }),
    },
  };
}

// export function storeSession (data = {}) {
//   return {
//     type: STORE_SESSION,
//     AWAIT_MARKER,
//     payload: {
//       data,
//       [STORE_SESSION]: AsyncStorage.setItem(SESSION, JSON.stringify(data))
//     }
//   }
// }

// export function clearSession (data = {}) {
//   return {
//     type: CLEAR_SESSION,
//     AWAIT_MARKER,
//     payload: {
//       [CLEAR_SESSION]: AsyncStorage.removeItem(SESSION)
//     }
//   }
// }

// export function login (data) {
//   return {
//     type: LOGIN,
//     AWAIT_MARKER,
//     payload: {
//       [LOGIN]: client.post('User/login', { data })
//     }
//   }
// }

// export function isGuest (payload = true) {
//   return {
//     payload,
//     type: IS_GUEST
//   }
// }
