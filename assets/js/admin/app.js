import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import {Router, Route, IndexRoute} from 'react-router';
import {syncReduxAndRouter} from 'redux-simple-router';
import createBrowserHistory from 'history/lib/createBrowserHistory';
import store from './store/store';
import routes from './routes';

const history = createBrowserHistory();

syncReduxAndRouter(history, store);

const childrenRoutes = routes(store);

ReactDOM.render(
  <Provider store={store}>
    <Router history={history} children={childrenRoutes} />
  </Provider>
  , document.getElementById('app'));