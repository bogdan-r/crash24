import moment from 'moment';

export default {
  status(user) {
    if(user.get('isVerification')) {
      return 'Подтвержден'
    } else {
      return 'Не подтвержден'
    }
  },

  created(user) {
    return moment(user.get('createdAt')).format('LL')
  },

  smallAvatar(user) {
    return user.get('avatars').get('avatar_small')
  },

  avatar(user) {
    return user.get('avatars').avatar
  }
}