import React from 'react';
import { Link } from 'react-router';

import _ from 'lodash';
import {
  Table,
  TableBody,
  TableFooter,
  TableHeader,
  TableHeaderColumn,
  TableRow,
  TableRowColumn,
  Avatar
} from 'material-ui';
import EditIcon from 'material-ui/lib/svg-icons/editor/mode-edit';

import UserPresenter from './../../presenters/UserPresenter'

export default class ListPage extends React.Component {
  render() {
    return <div className='row'>
      <div className='col-xs-12'>
        <h1>Пользователи</h1>
        <Table
          multiSelectable={true}
        >
          <TableHeader>
            <TableRow>
              <TableHeaderColumn style={{width: 30}}>ID</TableHeaderColumn>
              <TableHeaderColumn style={{width: 45}}>Аватар</TableHeaderColumn>
              <TableHeaderColumn>Никнейм</TableHeaderColumn>
              <TableHeaderColumn>Email</TableHeaderColumn>
              <TableHeaderColumn>Статус</TableHeaderColumn>
              <TableHeaderColumn>Дата регистрации</TableHeaderColumn>
              <TableHeaderColumn>&nbsp;</TableHeaderColumn>
            </TableRow>
          </TableHeader>
          <TableBody>
            {this.renderUsers()}
          </TableBody>
        </Table>

      </div>
    </div>
  }

  renderUsers() {
    const users = this.props.userList;
    return users.map((user)=> {
      return <TableRow key={user.get('id')}>
        <TableRowColumn style={{width: 30}}>{user.get('id')}</TableRowColumn>
        <TableRowColumn style={{width: 45}}>
          <Avatar src={UserPresenter.smallAvatar(user)}/>
        </TableRowColumn>
        <TableRowColumn>{user.get('username')}</TableRowColumn>
        <TableRowColumn>{user.get('email')}</TableRowColumn>
        <TableRowColumn>{UserPresenter.status(user)}</TableRowColumn>
        <TableRowColumn>{UserPresenter.created(user)}</TableRowColumn>
        <TableRowColumn style={{textAlign: 'right'}}>
          <Link to={`/admin/users/${user.get('id')}`}>
            <EditIcon color='rgba(0, 0, 0, 0.54)'/>
          </Link>
        </TableRowColumn>
      </TableRow>
    })
  }
}

ListPage.propTypes = {
  userList: React.PropTypes.object.isRequired
};