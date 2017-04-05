import React, { Component } from 'react';

export default class ContactsFilter extends Component {
  render() {
    return (
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
    )
  }
}
