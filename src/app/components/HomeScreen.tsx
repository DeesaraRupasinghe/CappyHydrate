import { useState } from "react";
import { useNavigate } from "react-router";
import { ImageWithFallback } from "./figma/ImageWithFallback";
import { Droplet, Settings, TrendingUp } from "lucide-react";

export function HomeScreen() {
  const navigate = useNavigate();
  const [waterCount, setWaterCount] = useState(2);
  const totalGoal = 4;

  const handleDrinkWater = () => {
    if (waterCount < totalGoal) {
      setWaterCount(waterCount + 1);
    }
  };

  return (
    <div className="h-screen w-full max-w-md mx-auto flex flex-col bg-gradient-to-b from-[#f5ebe0] to-[#e3d5ca] relative overflow-hidden">
      {/* Header */}
      <div className="flex justify-between items-center p-6 z-10">
        <button
          onClick={() => navigate("/setup")}
          className="p-3 rounded-full bg-white/70 shadow-md hover:bg-white/90 transition-all"
        >
          <Settings className="w-5 h-5 text-[#bc6c25]" />
        </button>
        <button
          onClick={() => navigate("/progress")}
          className="p-3 rounded-full bg-white/70 shadow-md hover:bg-white/90 transition-all"
        >
          <TrendingUp className="w-5 h-5 text-[#bc6c25]" />
        </button>
      </div>

      {/* Decorative elements */}
      <div className="absolute top-20 right-5 w-24 h-24 rounded-full bg-[#a8dadc] opacity-20 blur-2xl"></div>
      <div className="absolute bottom-40 left-5 w-32 h-32 rounded-full bg-[#dda15e] opacity-15 blur-2xl"></div>

      {/* Main content */}
      <div className="flex-1 flex flex-col items-center justify-center px-8 z-10">
        {/* Capybara illustration */}
        <div className="w-56 h-56 mb-6 rounded-[3rem] overflow-hidden shadow-2xl border-4 border-white/60">
          <ImageWithFallback
            src="https://images.unsplash.com/photo-1595017013941-cab3d4c8d02f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjdXRlJTIwY2FweWJhcmElMjByZWxheGluZ3xlbnwxfHx8fDE3NzQ5NjE2ODB8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral"
            alt="Capybara holding water bottle"
            className="w-full h-full object-cover"
          />
        </div>

        {/* Main message */}
        <h2 className="text-2xl text-center text-[#8b7355] mb-8 px-4">
          Your capybara reminds you to drink water 💧
        </h2>

        {/* Progress display */}
        <div className="bg-white/80 rounded-3xl px-8 py-6 shadow-lg mb-8 backdrop-blur-sm">
          <div className="text-center mb-4">
            <span className="text-5xl text-[#bc6c25]">{waterCount}</span>
            <span className="text-3xl text-[#8b7355]">/{totalGoal}</span>
          </div>
          <div className="flex gap-2 justify-center">
            {Array.from({ length: totalGoal }).map((_, index) => (
              <Droplet
                key={index}
                className={`w-6 h-6 ${
                  index < waterCount
                    ? "text-[#a8dadc] fill-[#a8dadc]"
                    : "text-gray-300"
                }`}
              />
            ))}
          </div>
          <p className="text-sm text-[#8b7355] text-center mt-3">bottles completed</p>
        </div>

        {/* Main action button */}
        <button
          onClick={handleDrinkWater}
          disabled={waterCount >= totalGoal}
          className="w-full max-w-xs bg-gradient-to-r from-[#a8dadc] to-[#457b9d] text-white text-xl py-5 rounded-full shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100"
        >
          {waterCount >= totalGoal ? "Goal Complete! 🎉" : "I Drank Water!"}
        </button>

        {/* Next reminder */}
        <p className="text-sm text-[#8b7355] mt-6 text-center">
          ⏰ Next reminder in 2 hours
        </p>
      </div>

      {/* Bottom decorative wave */}
      <div className="absolute bottom-0 left-0 right-0 h-20 bg-gradient-to-t from-[#d6ccc2] to-transparent"></div>
    </div>
  );
}
