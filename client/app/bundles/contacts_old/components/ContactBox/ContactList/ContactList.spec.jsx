import { React, expect, TestUtils } from 'libs/testHelper';
import { List, Map } from 'immutable';

// import ContactList from './ContactList';
// import Contact from './Contact/Contact';

const {
  renderIntoDocument,
  findRenderedDOMComponentWithTag,
  scryRenderedComponentsWithType,
} = TestUtils;

const cssTransitionGroupClassNames = {
  enter: 'elementEnter',
  enterActive: 'elementEnterActive',
  leave: 'elementLeave',
  leaveActive: 'elementLeaveActive',
};

// describe('ContactList', () => {
//   const contacts = List.of(
//     new Map({
//       id: 1,
//       firstName: 'Frank',
//       lastName: 'Smith',
//     }),
//     new Map({
//       id: 2,
//       firstName: 'John',
//       lastName: 'Jones',
//     }),
//   );

//   it('renders a list of Contacts in normal order', () => {
//     const component = renderIntoDocument(
//       <ContactList
//         $$contacts={contacts}
//         cssTransitionGroupClassNames={cssTransitionGroupClassNames}
//       />,
//     );
//     const list = scryRenderedComponentsWithType(component, Contact);
//     expect(list.length).to.equal(2);
//     expect(list[0].props.firstName).to.equal('Frank');
//     expect(list[1].props.firstName).to.equal('John');
//   });

//   it('renders an alert if errors', () => {
//     const component = renderIntoDocument(
//       <ContactList
//         $$contacts={contacts} error="zomg"
//         cssTransitionGroupClassNames={cssTransitionGroupClassNames}
//       />,
//     );

//     const alert = findRenderedDOMComponentWithTag(component, 'strong');
//     expect(alert.textContent).to.equal('Contacts could not be retrieved. ');
//   });
// });
