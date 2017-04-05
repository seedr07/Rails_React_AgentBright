import { combineReducers } from 'redux';
import { reducer as awaitReducer } from 'redux-await';
import { reducer as app } from './app';

export default combineReducers({
  app,
  await: awaitReducer,
});
