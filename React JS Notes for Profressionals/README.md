# React JS Notes for Professionals

![](https://i.imgur.com/waxVImv.png)

### [View all DevNotes](../README.md)

![](https://i.imgur.com/waxVImv.png)

## Chapter 1: Getting started with React

- side-effect
- state
- props
- component

## Chapter 2: Components

- stateless
- stateful

### Section 2.1: Creating Components

**Stateless Functional Components**
In many applications there are smart components that hold state but render dumb components that simply receive props and return HTML as JSX. Stateless functional components are much more reusable and have a positive performance impact on your application.
They have 2 main characteristics:

- When rendered they receive an object with all the props that were passed down
- They must return the JSX to be rendered

```jsx
// When using JSX inside a module you must import React
import React from 'react';
import PropTypes from 'prop-types';

const FirstComponent = (props) => (
  <div>Hello, {props.name}! I am a FirstComponent.</div>
);

//arrow components also may have props validation
FirstComponent.propTypes = {
  name: PropTypes.string.isRequired,
};

// To use FirstComponent in another file it must be exposed through an export call:
export default FirstComponent;
```

**Stateful Components**
In contrast to the 'stateless' components shown above, 'stateful' components have a state object that can be updated with the setState method. The state must be initialized in the constructor before it can be set:

```jsx
import React, { Component } from 'react';

class SecondComponent extends Component {
  constructor(props) {
    super(props);

    this.state = { toggle: true };

    // This is to bind context when passing onClick as a callback
    this.onClick = this.onClick.bind(this);
  }

  onClick() {
    this.setState((prevState, props) => ({
      toggle: !prevState.toggle,
    }));
  }

  render() {
    return (
      <div onClick={this.onClick}>
        Hello, {this.props.name}! I am a SecondComponent.
        <br />
        Toggle is: {this.state.toggle}
      </div>
    );
  }
}
```

**Higher Order Components**
Higher order components (HOC) allow to share component functionality.

```jsx
import React, { Component } from 'react';

const PrintHello = (ComposedComponent) =>
  class extends Component {
    onClick() {
      console.log('hello');
    }

    /* The higher order component takes another component as a parameter
    and then renders it with additional props */ render() {
      return (
        <ComposedComponent
          {...this.props}
          onClick={this.onClick}
        />
      );
    }
  };
const FirstComponent = (props) => (
  <div onClick={props.onClick}>Hello, {props.name}! I am a FirstComponent.</div>
);
const ExtendedComponent = PrintHello(FirstComponent);
```

### Section 2.2: Basic Component

**index.html**

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>React Tutorial</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.2.1/react.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.2.1/react-dom.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.min.js"></script>
  </head>
  <body>
    <div id="content"></div>
    <script
      type="text/babel"
      src="scripts/example.js"
    ></script>
  </body>
</html>
```

**scripts/example.js**

```jsx
import React, { Component } from 'react';
import ReactDOM from 'react-dom';

class FirstComponent extends Component {
  render() {
    return (
      <div className='firstComponent'>Hello, world! I am a FirstComponent.</div>
    );
  }
}
ReactDOM.render(
  <FirstComponent />, // Note that this is the same as the variable you stored above
  document.getElementById('content')
);
```

**Section 2.3: Nesting Components**

```jsx
var React = require('react');
var createReactClass = require('create-react-class');

var CommentList = reactCreateClass({
  render: function () {
    return <div className='commentList'>Hello, world! I am a CommentList.</div>;
  },
});

var CommentForm = reactCreateClass({
  render: function () {
    return <div className='commentForm'>Hello, world! I am a CommentForm.</div>;
  },
});
```

You can nest and refer to those components in the definition of a different component:

```jsx
var React = require('react');
var createReactClass = require('create-react-class');

var CommentBox = reactCreateClass({
  render: function () {
    return (
      <div className='commentBox'>
        <h1>Comments</h1>
        <CommentList /> // Which was defined above and can be reused
        <CommentForm /> // Same here
      </div>
    );
  },
});
```

**1. Nesting without using children**

```jsx
var CommentList = reactCreateClass({
  render: function () {
    return (
      <div className='commentList'>
        <ListTitle />
        Hello, world! I am a CommentList.
      </div>
    );
  },
});
```

This is the style where A composes B and B composes C.

**Pros**

- Easy and fast to separate UI elements
- Easy to inject props down to children based on the parent component's state

**Cons**

- Less visibility into the composition architecture
- Less reusability

**Good if**

- B and C are just presentational components
- B should be responsible for C's lifecycle

**2. Nesting using children**

```jsx
var CommentBox = reactCreateClass({
  render: function () {
    return (
      <div className='commentBox'>
        <h1>Comments</h1>
        <CommentList>
          <ListTitle /> // child
        </CommentList>
        <CommentForm />
      </div>
    );
  },
});
```

This is the style where A composes B and A tells B to compose C. More power to parent components.

**Pros**

- Better components lifecycle management
- Better visibility into the composition architecture
- Better reusuability

**Cons**

- Injecting props can become a little expensive
- Less flexibility and power in child components

**Good if**

- B should accept to compose something different than C in the future or somewhere else
- A should control the lifecycle of C

**3. Nesting using props**

```jsx
var CommentBox = reactCreateClass({
  render: function () {
    return (
      <div className='commentBox'>
        <h1>Comments</h1>
        <CommentList title={ListTitle} /> //prop
        <CommentForm />
      </div>
    );
  },
});
```

This is the style where A composes B and B provides an option for A to pass something to compose for a specific purpose. More structured composition.
**Pros**

- Composition as a feature
- Easy validationBetter composaiblility

**Cons**

- Injecting props can become a little expensive
- Less flexibility and power in child components

**Good if**

- B has specific features defined to compose something
- B should only know how to render not what to render

`#3` is usually a must for making a public library of components but also a good practice in general to make composable components and clearly define the composition features. `#1` is the easiest and fastest to make something that works, but `#2` and `#3` should provide certain benefits in various use cases.

### Section 2.4: Props

Props are a way to pass information into a React component, they can have any type including functions - sometimes referred to as callbacks.

In JSX props are passed with the attribute syntax

```jsx
<MyComponent userID={123} />
```

Inside the definition for MyComponent userID will now be accessible from the props object

```jsx
// The render function inside MyComponent
render() {
  return (
    <span>The user's ID is {this.props.userID}</span>
  )
}
```

It's important to define all props, their types, and where applicable, their default value:

```jsx
// defined at the bottom of MyComponent
MyComponent.propTypes = {
  someObject: React.PropTypes.object,
  userID: React.PropTypes.number.isRequired,
  title: React.PropTypes.string,
};

MyComponent.defaultProps = {
  someObject: {},
  title: 'My Default Title',
};
```

### Section 2.5: Component states - Dynamic user-interface
