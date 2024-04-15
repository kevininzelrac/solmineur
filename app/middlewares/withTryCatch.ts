const withTryCatch = async <T>(query: T, message?: string) => {
  try {
    return { data: await query, error: null };
  } catch (error) {
    if (error instanceof Error) {
      if (process.env.NODE_ENV === "development")
        return { data: null, error: { message: error.message } };
      else
        return {
          data: null,
          error: { message: message || "Unexpected Server Error" },
        };
    }
    return { data: null, error: { message: "Unknown Error" } };
  }
};

export default withTryCatch;
