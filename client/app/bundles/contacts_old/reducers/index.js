import contactsReducer, { $$initialState as $$contactsState } from './contactsReducer';
import railsContextReducer, { initialState as railsContextState } from './railsContextReducer';

export default {
  $$contactsStore: contactsReducer,
  railsContext: railsContextReducer,
};

export const initialStates = {
  $$contactsState,
  railsContextState,
};
