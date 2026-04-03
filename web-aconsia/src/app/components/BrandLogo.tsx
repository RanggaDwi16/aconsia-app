import logoImage from "../../assets/1c448958f0817c176999b741d53bcc5ce9b3930d.png";

type BrandLogoProps = {
  wrapperClassName?: string;
  imageClassName?: string;
};

export function BrandLogo({
  wrapperClassName = "inline-flex items-center justify-center w-20 h-20 bg-white rounded-full shadow-md",
  imageClassName = "w-14 h-14 object-contain",
}: BrandLogoProps) {
  return (
    <div className={wrapperClassName}>
      <img src={logoImage} alt="ACONSIA Logo" className={imageClassName} />
    </div>
  );
}
