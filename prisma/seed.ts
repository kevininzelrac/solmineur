import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  await prisma.user.upsert({
    where: { email: "kevin@prisma.io" },
    update: {},
    create: {
      email: "kevin@prisma.io",
      fullname: "Kevin The Dude",
      firstname: "Kevin",
      lastname: "The Dude",
      avatar:
        "https://fastly.picsum.photos/id/962/200/200.jpg?hmac=XehF7z9JYkgC-2ZfSP05h7eyumIq9wNKUDoCLklIhr4",
      credential: {
        create: {
          passwordHash: process.env.PWD_HASH,
        },
      },
    },
  });
  await prisma.user.upsert({
    where: { email: "sebastian@prisma.io" },
    update: {},
    create: {
      email: "sebastian@prisma.io",
      fullname: "Sebastian eL Patron",
      firstname: "Sebastian",
      lastname: "El Patron",
      avatar:
        "https://fastly.picsum.photos/id/249/200/200.jpg?hmac=75zqoHvrxGGVnJnS8h0gUzZ3zniIk6PggG38GjmyOto",
      credential: {
        create: {
          passwordHash: process.env.PWD_HASH,
        },
      },
    },
  });

  const getAuthorId = async (email: string) => {
    const user = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        id: true,
      },
    });
    if (!user) throw new Error("Can't find authorId");
    return user.id;
  };

  // Création des types
  await prisma.type.createMany({
    data: [{ title: "page" }, { title: "post" }, { title: "menu" }],
  });
  const types = await prisma.type.findMany();

  // Création des catégories
  await prisma.category.createMany({
    data: [
      { title: "default", typeTitle: "page" },
      { title: "art", typeTitle: "post" },
      { title: "music", typeTitle: "post" },
      { title: "travels", typeTitle: "post" },
      { title: "tech", typeTitle: "post" },
    ],
  });
  const categories = await prisma.category.findMany();

  await prisma.post.createMany({
    data: [
      {
        title: "Introduction to JavaScript",
        content: "Lorem ipsum...",
        authorId: await getAuthorId("kevin@prisma.io"),
        typeTitle: "post",
        categoryTitle: "tech",
      },
      {
        title: "The wonders of the universe",
        content: "Lorem ipsum...",
        authorId: await getAuthorId("sebastian@prisma.io"),
        typeTitle: "post",
        categoryTitle: "travels",
      },
      {
        title: "Exploring new places",
        content: "Lorem ipsum...",
        authorId: await getAuthorId("sebastian@prisma.io"),
        typeTitle: "post",
        categoryTitle: "travels",
      },
      {
        title: "Cooking adventures",
        authorId: await getAuthorId("kevin@prisma.io"),
        content: "Lorem ipsum...",
        typeTitle: "post",
        categoryTitle: "art",
      },
      {
        title: "Staying fit and healthy",
        content: "Lorem ipsum...",
        authorId: await getAuthorId("sebastian@prisma.io"),
        typeTitle: "post",
        categoryTitle: "music",
      },
      {
        title: "The power of music",
        content: "Lorem ipsum...",
        authorId: await getAuthorId("kevin@prisma.io"),
        typeTitle: "post",
        categoryTitle: "music",
      },
      {
        title: "Thrilling sports moments",
        content: "Lorem ipsum...",
        authorId: await getAuthorId("sebastian@prisma.io"),
        typeTitle: "post",
        categoryTitle: "art",
      },
      {
        title: "Fashion trends of the season",
        content: "Lorem ipsum...",
        authorId: await getAuthorId("sebastian@prisma.io"),
        typeTitle: "post",
        categoryTitle: "art",
      },
      {
        title: "Exploring the world of art",
        content: "Lorem ipsum...",
        authorId: await getAuthorId("kevin@prisma.io"),
        typeTitle: "post",
        categoryTitle: "art",
      },
      {
        title: "Connecting with nature",
        content: "Lorem ipsum...",
        authorId: await getAuthorId("sebastian@prisma.io"),
        typeTitle: "post",
        categoryTitle: "travels",
      },
    ],
  });
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
