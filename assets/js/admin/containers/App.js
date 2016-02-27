import React from 'react';
import {AppBar, Menu, MenuItem, FontIcon} from 'material-ui';
import SocialGroupIcon from 'material-ui/lib/svg-icons/social/group';

export default class App extends React.Component {
  render() {
    return <div className='row'>
      <div className='col-xs-12'>
        <AppBar
          title='Административная часть'
        />
        <div className="row">
          <div className="col-xs-3">
            <Menu
              autoWidth={false}
            >
              <MenuItem
                primaryText="Пользователи"
                leftIcon={<SocialGroupIcon />}
                style={{width: '100%'}}
              />
            </Menu>
          </div>
          <div className="col-xs-9 content-column">
            {this.props.children}
          </div>
        </div>
      </div>
    </div>
  }
}