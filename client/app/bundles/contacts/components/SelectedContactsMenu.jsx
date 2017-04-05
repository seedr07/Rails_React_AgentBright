import React, { Component } from 'react';
import { Icon, Menu, Popup } from 'semantic-ui-react';

export default class SelectedContactsMenu extends Component {
  renderGradePopup() {
    return (
      <div>
        <h5>Change the grade of 3 contacts to::</h5>
        <div className="ui large labels">
          <a className="ui green circular basic label">A+</a>
          <a className="ui teal circular basic label">A</a>
          <a className="ui yellow circular basic label">B</a>
          <a className="ui orange circular basic label">C</a>
          <a className="ui red circular basic label">D</a>
          <a className="ui grey circular basic label">NA</a>
          <a href="#">Cancel</a>
        </div>
      </div>
    );
  }

  render() {
    return (
      <Menu inverted>
        <Menu.Menu>
          <Menu.Item name="Edit groups" />
          <Popup
            trigger={<Menu.Item name="Edit grades" />}
            on="click"
            positioning="bottom left"
            flowing
            content={this.renderGradePopup()}
            mountNode={document.body}
          />
        </Menu.Menu>
        <div className="borderless item">
          <span>3 Contacts Selected | <a>Clear</a></span>
        </div>
        <Menu.Menu position="right">
          <Menu.Item name="Merge" />
          <Menu.Item>
            <Icon name="trash outline" size="large" className="m-a-0" />
          </Menu.Item>
        </Menu.Menu>
      </Menu>
    )
  }
}
