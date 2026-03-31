import { useEffect } from "react";
import { useNavigate } from "react-router";
import { ImageWithFallback } from "./figma/ImageWithFallback";

export function SplashScreen() {
  const navigate = useNavigate();

  useEffect(() => {
    const timer = setTimeout(() => {
      navigate("/setup");
    }, 3000);

    return () => clearTimeout(timer);
  }, [navigate]);

  return (
    <div className="h-screen w-full max-w-md mx-auto flex flex-col items-center justify-center bg-gradient-to-b from-[#f5ebe0] via-[#e3d5ca] to-[#d6ccc2] relative overflow-hidden">
      {/* Decorative circles */}
      <div className="absolute top-10 left-10 w-32 h-32 rounded-full bg-[#a8dadc] opacity-30 blur-2xl"></div>
      <div className="absolute bottom-20 right-10 w-40 h-40 rounded-full bg-[#dda15e] opacity-20 blur-2xl"></div>

      {/* Main content */}
      <div className="flex flex-col items-center justify-center z-10 px-8">
        <div className="w-52 h-52 mb-8 rounded-full overflow-hidden shadow-2xl border-4 border-white/50 animate-[bounce_2s_ease-in-out_infinite]">
          <ImageWithFallback
            src="https://images.unsplash.com/photo-1577049207999-5a9745cdecb6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjYXB5YmFyYSUyMGRyaW5raW5nJTIwd2F0ZXJ8ZW58MXx8fHwxNzc0OTYxNjgwfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral"
            alt="Adorable capybara drinking water"
            className="w-full h-full object-cover"
          />
        </div>

        <h1 className="text-5xl mb-4 text-[#bc6c25] tracking-wide" style={{ fontFamily: 'Georgia, serif' }}>
          Cappy Water
        </h1>

        <p className="text-xl text-[#8b7355] italic tracking-wide">
          Stay hydrated with love
        </p>

        {/* Loading dots */}
        <div className="flex gap-2 mt-12">
          <div className="w-3 h-3 rounded-full bg-[#a8dadc] animate-[bounce_1s_ease-in-out_0s_infinite]"></div>
          <div className="w-3 h-3 rounded-full bg-[#a8dadc] animate-[bounce_1s_ease-in-out_0.2s_infinite]"></div>
          <div className="w-3 h-3 rounded-full bg-[#a8dadc] animate-[bounce_1s_ease-in-out_0.4s_infinite]"></div>
        </div>
      </div>
    </div>
  );
}
