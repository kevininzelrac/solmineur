import { LinksFunction } from "@remix-run/node";

import root from "./root.css?url";
import reset from "./reset.css?url";

const links: LinksFunction = () => [
  { rel: "stylesheet", href: root },
  { rel: "stylesheet", href: reset },
];

export default links;
