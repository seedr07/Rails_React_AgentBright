import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as contactsActionCreators from '../actions/contactsActionCreators';

import {
  Button,
  Dropdown,
  Input
} from 'semantic-ui-react';

const ContaxSearchBar = ({onSearch, search}) => (
  <div className="ab-search-bar-header">
    <div className="ab-search-bar-header-left">
      <Input
        icon='search'
        placeholder='Search contacts...'
        fluid
        value={search}
        onChange={(e) => onSearch(e.target.value)}
      />
    </div>
    <div className="ab-search-bar-header-right">
      <div className="p-l display-inline-block">
        <Button basic className="hide-tablet-and-up">Filter</Button>
        <Dropdown button basic text="Sort">
          <Dropdown.Menu>
            <Dropdown.Header>Sort contacts by</Dropdown.Header>
            <Dropdown.Item text="Recommended" />
            <Dropdown.Item text="Most Recent" />
            <Dropdown.Item text="Least Recent" />
            <Dropdown.Item text="Grade" />
            <Dropdown.Item text="Grade (Z-A+)" />
            <Dropdown.Item text="Least Recent" />
            <Dropdown.Item text="Most Contacted" />
            <Dropdown.Item text="Least Contacted" />
            <Dropdown.Item text="First Name" />
            <Dropdown.Item text="First Name (Z-A)" />
            <Dropdown.Item text="Last Name" />
            <Dropdown.Item text="Last Name (Z-A)" />
          </Dropdown.Menu>
        </Dropdown>
      </div>

    </div>
  </div>
);

export default ContaxSearchBar;
