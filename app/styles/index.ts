import { LinksFunction } from "@remix-run/node";

import root from "./root.css?url";
import reset from "./reset.css?url";
import variables from "./variables.css?url";
import nav from "./nav.css?url";

const links: LinksFunction = () => [
  { rel: "stylesheet", href: root },
  { rel: "stylesheet", href: reset },
  { rel: "stylesheet", href: variables },
  { rel: "stylesheet", href: nav },
];

export default links;
