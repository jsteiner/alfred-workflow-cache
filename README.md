# Alfred Workflow Cache

A library for caching and searching data for [Alfred] workflows.

[Alfred]: https://www.alfredapp.com/

## Functions

* `writeItems` - writes the passed items to a CSV.
* `searchItems` - fuzzy searches and returns all matching items in an Alfred
  supported XML format. Sorts by the number of visits.
* `incrementVisits` - increments the visit count of the passed url.
* `ToAlfredItem` - a typeclass for converting to the supported `Alfred.Item`
  type.

See [Trelfred] and [Gitfred] for example usage.

[Trelfred]: https://github.com/jsteiner/trelfred
[Gitfred]: https://github.com/jsteiner/gitfred

## License

Alfred Workflow Cache is Copyright © 2016 Josh Steiner. It is free software, and
may be redistributed under the terms specified in the LICENSE file.
