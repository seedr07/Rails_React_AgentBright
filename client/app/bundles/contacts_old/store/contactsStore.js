import { compose, createStore, applyMiddleware, combineReducers } from 'redux';
import thunkMiddleware from 'redux-thunk';
import loggerMiddleware from 'libs/middlewares/loggerMiddleware';
import reducers, { initialStates } from '../reducers';

export default (props, railsContext) => {
  const initialContacts = props.contacts;
  const { $$contactsState } = initialStates;
  const initialState = {
    $$contactsStore: $$contactsState.merge({
      $$contacts: initialContacts,
    }),
    railsContext,
  };

  const enhancers = compose(
    window.devToolsExtension ? window.devToolsExtension() : f => f
  );

  const reducer = combineReducers(reducers);
  const composedStore = compose(
    applyMiddleware(thunkMiddleware, loggerMiddleware),
  );

  return composedStore(createStore)(reducer, initialState, enhancers);
};
