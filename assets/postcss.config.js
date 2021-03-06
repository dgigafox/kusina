module.exports = {
  plugins: [
    require('postcss-import'),
    require('tailwindcss'), // finds Tailwind directives in CSS and replaces them with CSS generated by Tailwind
    require('autoprefixer') // adds vendor prefixes such as -webkit, -moz, and -ms to CSS
  ]
};