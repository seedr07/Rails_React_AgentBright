import { compose, createStore, applyMiddleware, combineReducers } from 'redux';
import thunkMiddleware from 'redux-thunk';
import { fromJS } from 'immutable';
import loggerMiddleware from 'libs/middlewares/loggerMiddleware';
import reducers, { initialStates } from '../reducers';

const composeInitialState = (railsProps) => ({
//   entities: {
//     $$contacts: railsProps,
//   }
//   contactsScreen: {
//     isFetching: false,
//   }
  $$contactsStore: initialStates.$$contactsState.mergeDeep({
    $$contacts: fromJS(railsProps.contacts),
  }),
});

export default (railsProps, railsContext) => {
  const reducer = combineReducers(reducers);
  const initialState = composeInitialState(railsProps);
  const enhancers = compose(
    window.devToolsExtension ? window.devToolsExtension() : f => f,
    applyMiddleware(thunkMiddleware, loggerMiddleware),
  );

  return createStore(reducer, initialState, enhancers);
};
