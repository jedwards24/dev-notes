# Package Overview Notes

Planned functions to do and thoughts about what might go where.

## Current and Possible Packages

Current:

* edwards. Main package. Mainly EDS and general utils. Functions to work with files.
* jemodel. Model tuning and fitting. Preprocessing data for model input (not general cleaning). Evaluation of model output. Not heavily developed.
* jemisc - infrequently used funtions.
* response - Just the `response()` function for CIs of the mean of a response by grouping variables.

## Package Roles

I'm using `edwards` as a general use package. It is easy to have one library command whenever I do data science work. I'm wary of it becoming a dumping ground for lots of miscellaneous functions, but I'm not sure of what exactly the main issues are.

* Clutter. Interferes with development and maintenance.
* Clutter in use e.g. help files.
* Less clarity on how functions connect to each other.
* Increased dependencies.
* Harder to track changes between versions. NEWS becomes cluttered. I want to emphasise breaking changes in core functions but might not care much on peripheral functions - different parts of the package might develop at different speeds.
* Harder to track issues and todos.

For some functions, it is more about having a place to keep them rather than how I use them. For these having separate packages is easier to develop and maintain.


## Possible Future Packages

DF comparison package. Write up full review of existing options first. Names: mirror, looking glass, ferret, dig, rabbit hole.

