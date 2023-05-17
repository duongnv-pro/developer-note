<!-- @format -->

# The Complete 2023 Web Development Bootcamp

![](https://i.imgur.com/waxVImv.png)

## [View all DevNotes](../README.md)

![](https://i.imgur.com/waxVImv.png)

### A Note About 2023 Course Updates

- https://appbrewery.com/p/legacy-complete-web-development-course/

#### What is HTML?

HyperText Markup Language

#### The List Element

ul - Unordered List
ol - Ordered List

li - List items

#### Anchor Elements

- href

#### The HTML Boilerplate

<!DOCTYPE html>
<html lang="en">
  <head>...
  <body>
  <footer>
</html>

#### What is CSS?

Cascading Styles Sheets

#### How to add CSS

- Inline: <h1 style="color:blue;">...</h1> - Element
- Internal: <style>...</style> - Page
- External: <link rel="stylesheet" href="style.css" /> - Website

### CSS Selectors

- Element: h1, h2, p, ul, li
- Class: .this-is-a-class // many elements can have the same class
- ID: #this-is-an-id // only one element can have the same id
- Attribute: [type="checkbox"]
- Pseudo-class: :hover, :first-child
- Pseudo-element: ::before, ::after
- Combinators: div p, ul > li
- Grouping: h1, h2, p
- Universal: \*
- Descendant: div p
- Child: ul > li
- Adjacent Sibling: h1 + p
- General Sibling: h1 ~ p

```css
/* Element selector */
.red-text {
  color: red;
}

/* Class selector */
#main-heading {
  font-size: 50px;
}

// Attribute selector
p[draggable] {
  /* attribute selector with [attribute] */
  color: blue;
}
p[draggable='true'] {
  /* attribute selector with [attribute="value"] */
  color: red;
}

// Universal selector
* {
  color: red;
}
```

#### Colour Vocab Webstie

```css
#orange {
  color: orange;
}
```

### CSS Properties

#### Color Property

- https://colorhunt.co/

```css
html {
  background-color: #ffffff; /* property: value */
}

h1 {
  color: red;
}
```

#### Font Property

##### Font Size

1px = 1/96th of 1in, 0,26 mm
1pt = 1/72nd of 1in, 0,35 mm
1em = 100% of parent font size
1rem = 100% of root font size

with parent 1px, 1em will be 1px
with parent 16px, 1em will be 16px

```css
#pixel {
  font-size: 16px;
}
#point {
  font-size: 12pt;
}
#em {
  font-size: 1em;
}
#rem {
  font-size: 1rem;
}
```

##### Font Weight

- normal, bold: keywords
- lighter, bolder: relative to parent
- number: 100-900

```css
#normal {
  font-weight: normal;
}
```

##### Font Family

- font-family: "Times New Roman", Times, serif; // typeface, generic

- fonts.google.com

##### Text Align

- left, right, center, justify

```css
#left {
  text-align: left;
}
```

#### The CSS Box Model

- border: 1px solid black; // width, style, color
- padding: 10px; // top, right, bottom, left
- margin: 10px; // top, right, bottom, left

- margin > border > padding > content

```css
#border {
  border: 1px solid black;
}
```

### Intermediate CSS

#### The Cascade - Specificity, Inheritance and the Cascade

Imagine if this rule gets applied first, and then as the water falls down the cascade, it sees another rule that also applies to the same element. Which rule wins? Which rule gets applied? Well, that depends on the specificity of the rule. The more specific a rule is, the more likely it is to be applied.

Position > Specificity > Type > Important

```css
/* Position */
li {
  color: red;
  color: green; /* this will be applied */
}

/* Specificity: ID > Class > Attribute > Element > Universal > Inherited */
li {
  /* element */
  color: red;
}
.first-class {
  color: green;
} /* this will be applied */

li[draggable] {
  /* attribute */
  color: purple;
}
#first-id {
  color: orange;
} /* this will be applied */

/* Type: Inline > Internal > External */

/* Important: !important */
```

#### Compiling CSS Selectors

Group = Apply to both selectors

```css
selector1, selector2, selector3 { /* selector with comma and a space */
  property: value;
}

h1, h2 {
  color: blueviolet;
}
```

Child = Apply to direct with of left side

```css

selector1 > selector2 { /* parent > child */
  property: value;
}

.box > p {
  color: firebrick;
}
```

Descendant = Apply to a descendant of the left side

```css
selector1 selector2 { /* ancestor and descendant */
  property: value;
}

.box p {
  color: firebrick;
}
```
Chaining = Apply where ALL selectors are true

```css
selector1.selector2 { /* selector1 AND selector2 */
  property: value;
}
/* OR */
selector1selector2 { /* selector1 AND selector2: h1.box#heading OR #heading.box OR h1#heading .. */
  property: value;
}

li.done{
  color: seagreen;
}
```

Combining Combiners = Apply where ALL selectors are true

```css
selector1 selector2selector3 { /* ancestor and chain */
  property: value;
}

ul p.done {
  font-size: 0.5rem;
}
```
#### CSS Positioning
1. Static
2. Relative
3. Absolute
4. Fixed

**Static Positioning**
- HTML default flow

**Relative Positioning**
- Position relative to default position

**Absolute Positioning**
- Position relative to nearest positioned ancestor or top left corner of webpage

**Fixed Positioning**
- Position relative to top left corner of browser window

**z-index**
- Higher z-index will be on top

### Advanced CSS
#### Display CSS
Block, Inline and Inline-Block

**Block**
- Takes up entire width of page

```css
.box {
  display: block;
}
```

**Inline**
- Takes up entire width of

```html
<h2>Harry</h2>
<h2>Potter</h2>
```

```css
h2 {
  display: inline;
}
```

**Inline-Block**
- Takes up only as much width as needed

#### CSS Float

```html
<img .../>
<p>text ...</p>
<footer>Copyright App ...</footer>
```

```css
img {
  float: left;
}
footer {
  clear: left;
  /* clear: both; */
}
```
#### Responsive Website
1. Media Queries
2. CSS Grid
3. CSS Flex
4. External Frameworks e.g Bootstrap

##### Media Queries

```css
@media (max-width: 500px) {
  /* CSS for screens below or equal to 500px wide */
}
```
##### CSS Grid
```html
<div class="grid-container">
  <div class="first card"></div>
  <div class="card"></div>
  <div class="card"></div>
  <div class="card"></div>
  <div class="card"></div>
</div>
```
```css
.grid-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: 100px 200px 200px;
  grid-gap: 30px;
}
.first {
  grid-column: span 2;
}
.card {
  background-color: blue;
}
```
##### CSS Flexbox
```html
<div class="flex-container">
  <div class="first card"></div>
  <div class="second card"></div>
  <div class="card"></div>
  <div class="card"></div>
</div>
```
```css
.flex-container {
  display: flex;
}
.card {
  background-color: blue;
  border: 30px solid white;
  height: 100px;
  flex: 1;
}
.first {
  flex: 2;
}
.second {
  flex: 0.5;
}
```
```


