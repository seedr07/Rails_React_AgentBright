import reducer from './reducer';
import { middleware as awaitMiddleware } from 'redux-await';
import { createStore, applyMiddleware, compose } from 'redux';

export default initialState => {
  const enhancer = compose(
    applyMiddleware(awaitMiddleware)
  );
  return createStore(reducer, initialState, enhancer);
};
