import App from './../containers/App';
import UserPageList from './../containers/Users/UserPageList';
import UserPageItem from './../containers/Users/UserPageItem';

export default function routes(store) {
  return {
    component: App,
    path: '/admin',
    childRoutes: [{
      onEnter: UserPageList.onEnterCreator(store),
      component: UserPageList,
      path: 'users'
    }, {
      onEnter: UserPageItem.onEnterCreator(store),
      component: UserPageItem,
      path: 'users/:id'
    }]
  }
}