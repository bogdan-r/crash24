import * as UserTypes from './../constants/UserTypes';

export function requestUsers(users) {
  return {
    type: UserTypes.FETCH_REQUEST,
    users
  }
}

export function receiveUsers(users) {
  return {
    type: UserTypes.FETCH_RECEIVE,
    users
  }
}

export function requestUser(user) {
  return {
    type: UserTypes.FETCH_ITEM_REQUEST,
    user
  }
}

export function receiveUser(user) {
  return {
    type: UserTypes.FETCH_ITEM_RECEIVE,
    user
  }
}

export function fetchUsers() {
  return (dispatch) => {
    return fetch(`/api/admin/users/`)
      .then(res => res.json())
      .then(users => dispatch(receiveUsers(users)))
  }
}

export function fetchUser(userId) {
  return (dispatch) => {
    return fetch(`/api/admin/users/${userId}`)
      .then(res => res.json())
      .then(user => dispatch(receiveUser(user)))
  }
}

//TODO допилить правильный запрос на обновление
export function updateUser(userId, data) {
  return (dispatch) => {
    return fetch(`/api/admin/users/${userId}`, {
      method: 'UPDATE'
    })
      .then(res => res.json())
      .then(user => console.log('asdasd'))
  }
}