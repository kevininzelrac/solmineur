import type { MetaFunction } from "@remix-run/node";

export const meta: MetaFunction = () => {
  return [
    { title: "Remix - Vite - Prisma - AWS" },
    { name: "description", content: "Remix - Vite - Prisma - AWS" },
  ];
};

import loader from "./loader";
import { useLoaderData } from "@remix-run/react";
export { loader };

export default function Index() {
  const { posts } = useLoaderData<typeof loader>();

  return (
    <main>
      <h2>Blog</h2>
      <pre>{JSON.stringify(posts, null, 2)}</pre>
    </main>
  );
}
