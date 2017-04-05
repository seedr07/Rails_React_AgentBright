import BaseComponent from 'libs/components/BaseComponent';
import React, { PropTypes } from 'react';
import Immutable from 'immutable';

import ContactList, { ContactPropTypes } from './ContactList/ContactList';
import css from './ContactBox.scss';

import {
  Accordion,
  Button,
  Checkbox,
  Dropdown,
  Grid,
  Header,
  Icon,
  Input,
  Label,
  Menu,
  Modal,
  Segment,
  Table
} from 'semantic-ui-react';

export default class ContactBox extends BaseComponent {
  static propTypes = {
    pollInterval: PropTypes.number.isRequired,
    actions: PropTypes.shape({
      fetchContacts: React.PropTypes.function,
    }),
    data: PropTypes.shape({
      isFetching: React.PropTypes.boolean,
      isSaving: React.PropTypes.boolean,
      submitCommentError: React.PropTypes.string,
      $$contacts: React.PropTypes.arrayOf(ContactPropTypes),
    }).isRequired,
  };

  componentDidMount() {
    const { fetchContacts } = this.props.actions;
    fetchContacts();
    this.intervalId = setInterval(fetchContacts, this.props.pollInterval);
  }

  componentWillUnmount() {
    clearInterval(this.intervalId);
  }

  updateSearch(event) {
    let search = this.state.search;
  }

  render() {
    const { actions, data } = this.props;

    const cssTransitionGroupClassNames = {
      enter: css.elementEnter,
      enterActive: css.elementEnterActive,
      leave: css.elementLeave,
      leaveActive: css.elementLeaveActive,
    };

    // let filteredContacts = data.get('$$contacts').filter(
    //   (contact) => contact.get('name')
    //     toLowerCase().indexOf(this.state.search.toLowerCase()) !== -1);

    let filteredContacts = data.get('$$contacts');

    // return (
    //   <div className="contactBox container">
    //     <h2>
    //       Contacts {data.get('isFetching') && 'Loading...'}
    //     </h2>
    //     <p>
    //       <b>Text</b> supports Github Flavored Markdown.
    //       Contacts older than 24 hours are deleted.<br />
    //       <b>Name</b> is preserved. <b>Text</b> is reset, between submits.
    //     </p>
    //     <ContactList
    //       $$contacts={data.get('$$contacts')}
    //       error={data.get('fetchContactError')}
    //       cssTransitionGroupClassNames={cssTransitionGroupClassNames}
    //     />
    //   </div>
    // );

    return (
      <Grid stackable>
        <Grid.Column width={3}>
          <div className="ui vertical accordion menu fluid" data-ui-behavior="accordion-filter">
            <div className="item">
              <div className="title">
                <i className="dropdown icon"></i>
                Groups
              </div>
              <div className="content">
                <div className="ui form">
                  <div className="grouped fields">
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" name="example" />
                        <label className="fsi">None</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" name="example" />
                        <label>Current Clients</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" name="example" />
                        <label>Past Clients</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" name="example" />
                        <label>Realtors</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" name="example" />
                        <label>Vendors</label>
                      </div>
                    </div>
                  </div>
                  <a href="#">More ></a>
                </div>
              </div>
            </div>
            <div className="item">
              <div className="title">
                <i className="dropdown icon"></i>
                Grades
              </div>
              <div className="content">
                <div className="ui form">
                  <div className="grouped fields">
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">A+</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">A</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">B</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">C</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">D</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">N/A</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label className="fsi">None</label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="item">
              <div className="title">
                <i className="dropdown icon"></i>
                Owned By
              </div>
              <div className="content">
                <div className="ui form">
                  <div className="grouped fields">
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label className="fsi">None</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label>John Smith</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label>Jane Jones</label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="item">
              <div className="title">
                <i className="dropdown icon"></i>
                Transactions
              </div>
              <div className="content">
                <div className="ui form">
                  <div className="grouped fields">
                    <div className="field">
                      <div className="ui icon input">
                        <input
                          className="prompt"
                          type="text"
                          placeholder="Search transactions..."
                        />
                        <i className="search icon"></i>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="" className="fsi">None</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">19 Birch Hill Rd., Lyme</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">3544 Crowne Point Rd., Louisville</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">5 Essex Square, APT 2B, Essex</label>
                      </div>
                    </div>
                  </div>
                  <a href="#">See All ></a>
                </div>
              </div>
            </div>
            <div className="item">
              <div className="title">
                <i className="dropdown icon"></i>
                Campaigns
              </div>
              <div className="content">
                <div className="ui form">
                  <div className="grouped fields">
                    <div className="field">
                      <div className="ui icon input">
                        <input className="prompt" type="text" placeholder="Search campaigns..." />
                        <i className="search icon"></i>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label className="fsi">None</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label>>Monthly newsletter</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label>Lead recapture</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label>Christmas cards</label>
                      </div>
                    </div>
                  </div>
                  <a data-ui-behavior="see-all-campaigns-link">See All ></a>
                </div>
              </div>
            </div>
            <div className="item">
              <div className="title">
                <i className="dropdown icon"></i>
                Frequency
              </div>
              <div className="content m-t">
                <div className="ui tiny form">
                  <h5 className="ui dividing header">Last contacted:</h5>
                  <div className="two fields">
                    <div className="field">
                      <label htmlFor="last_contacted_after_date">After</label>
                      <div className="ui calendar" data-ui-behavior="calendar_date">
                        <div className="ui input left icon">
                          <i className="calendar icon"></i>
                          <input type="text" name="last_contacted_after_date" />
                        </div>
                      </div>
                    </div>
                    <div className="field">
                      <label htmlFor="last_contacted_before_date">Before</label>
                      <div className="ui calendar" data-ui-behavior="calendar_date">
                        <div className="ui input left icon">
                          <i className="calendar icon"></i>
                          <input type="text" name="last_contacted_before_date" />
                        </div>
                      </div>
                    </div>
                  </div>
                  <h5 className="ui dividing header">Added:</h5>
                  <div className="two fields">
                    <div className="field">
                      <label htmlFor="added_after_date">After</label>
                      <div className="ui calendar" data-ui-behavior="calendar_date">
                        <div className="ui input left icon">
                          <i className="calendar icon"></i>
                          <input type="text" name="added_after_date" />
                        </div>
                      </div>
                    </div>
                    <div className="field">
                      <label htmlFor="added_before_date">Before</label>
                      <div className="ui calendar" data-ui-behavior="calendar_date">
                        <div className="ui input left icon">
                          <i className="calendar icon"></i>
                          <input type="text" name="added_before_date" />
                        </div>
                      </div>
                    </div>
                  </div>
                  <h5 className="ui dividing header">Times contacted:</h5>
                  <div className="two fields">
                    <div className="field">
                      <label htmlFor="">Min</label>
                      <input type="text" />
                    </div>
                    <div className="field">
                      <label htmlFor="">Max</label>
                      <input type="text" />
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="item">
              <div className="title">
                <i className="dropdown icon"></i>
                Accounts
              </div>
              <div className="content">
                <div className="ui form">
                  <div className="grouped fields">
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">johnsmith@gmail.com</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">Facebook - John Smith</label>
                      </div>
                    </div>
                    <div className="field">
                      <div className="ui checkbox" data-ui-behavior="checkbox">
                        <input type="checkbox" />
                        <label htmlFor="">Twitter - @johnny234</label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </Grid.Column>
        <Grid.Column width={13}>
          <Segment.Group>
            <Segment>
              <div className="ab-search-bar-header">
                <div className="ab-search-bar-header-left">
                  <Input
                    icon='search'
                    placeholder='Search contacts...'
                    fluid
                    onChange={e => {
                      e.preventDefault();
                      store.dispatch({
                        type: 'SET_VISIBILITY_FILTER',
                        filter,
                      });
                    }}
                  />
                </div> {/* ab-search-bar-header-left */}
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

                </div> {/* ab-search-bar-header-right */}
              </div> {/* ab-search-bar-header */}
              <Segment basic className="p-a-0">
                {/* Labels go here */}
              </Segment>
            </Segment>
            <Segment className="p-a-0">
              <Table basic="very">
                <Table.Header>
                  <Table.Row>
                    <Table.HeaderCell collapsing></Table.HeaderCell>
                    <Table.HeaderCell collapsing>
                      <Checkbox
                        fitted
                      />
                    </Table.HeaderCell>
                    <Table.HeaderCell collapsing></Table.HeaderCell>
                    <Table.HeaderCell>Name</Table.HeaderCell>
                    <Table.HeaderCell collapsing>Grade</Table.HeaderCell>
                    <Table.HeaderCell>Group</Table.HeaderCell>
                    <Table.HeaderCell collapsing>Last Contact</Table.HeaderCell>
                    <Table.HeaderCell>Phone</Table.HeaderCell>
                  </Table.Row>
                </Table.Header>

                <ContactList
                  $$contacts={filteredContacts}
                  error={data.get('fetchContactError')}
                  cssTransitionGroupClassNames={cssTransitionGroupClassNames}
                />
              </Table>
            </Segment>

          </Segment.Group>
        </Grid.Column>
      </Grid>
    );

  }
}
