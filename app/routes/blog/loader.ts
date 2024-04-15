import { json } from "@remix-run/node";
import withTryCatch from "~/middlewares/withTryCatch";
import prisma from "~/services/prisma.server";

const loader = async () => {
  const posts = await withTryCatch(
    prisma.post.findMany({}),
    "Failed to fetch posts"
  );

  return json({ posts });
};
export default loader;
