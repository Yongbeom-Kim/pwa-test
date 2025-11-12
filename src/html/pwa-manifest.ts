export const getManifest = (manifestFileName: string) => {
  if (!manifestFileName.endsWith(".json")) {
    throw new Error("Manifest file name must end with .json");
  }

  const manifestFileStem = manifestFileName.slice(0, manifestFileName.length - 5)

  // return {
  //   name: "Basic PWA",
  //   short_name: "PWA",
  //   start_url: `/${manifestFileStem}?vesion=new`,
  //   display: "standalone",
  //   background_color: "#fff",
  //   description: "A basic PWA.",
  //   icons: [
  //     {
  //       src: `/assets/facebook_icon_1024_1024.png?manifestFileName=${manifestFileName}`,
  //       sizes: "1024x1024",
  //       type: "image/png",
  //     },
  //   ],
  // };

  return {
    name: "Basic PWA",
    short_name: "PWA",
    start_url: `/${manifestFileStem}?vesion=new`,
    display: "standalone",
    background_color: "#fff",
    description: "A basic PWA.",
    icons: [
      {
        src: `/assets/facebook_icon_1024_1024.png?manifestFileName=${manifestFileName}`,
        sizes: "1024x1024",
        type: "image/png",
      },
    ],
  };
};
