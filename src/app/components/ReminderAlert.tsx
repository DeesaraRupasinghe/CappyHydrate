import { useState } from "react";
import { useNavigate } from "react-router";
import { ImageWithFallback } from "./figma/ImageWithFallback";
import { Droplet, Clock } from "lucide-react";

export function ReminderAlert() {
  const navigate = useNavigate();
  const [isGlowing, setIsGlowing] = useState(true);

  const handleDrank = () => {
    navigate("/home");
  };

  const handleSnooze = () => {
    navigate("/home");
  };

  return (
    <div className="h-screen w-full max-w-md mx-auto flex items-center justify-center bg-gradient-to-b from-[#f5ebe0] via-[#e3d5ca] to-[#d6ccc2] relative overflow-hidden p-6">
      {/* Animated glow effect */}
      <div
        className={`absolute inset-0 ${
          isGlowing ? "animate-pulse" : ""
        }`}
      >
        <div className="absolute top-1/4 left-1/4 w-64 h-64 rounded-full bg-[#a8dadc] opacity-30 blur-3xl"></div>
        <div className="absolute bottom-1/4 right-1/4 w-64 h-64 rounded-full bg-[#457b9d] opacity-20 blur-3xl"></div>
      </div>

      {/* Main alert card */}
      <div className="relative z-10 w-full max-w-sm">
        <div className="bg-white/90 backdrop-blur-md rounded-[2.5rem] p-8 shadow-2xl border-4 border-white/60">
          {/* Capybara image */}
          <div className="w-48 h-48 mx-auto mb-6 rounded-[2rem] overflow-hidden shadow-xl border-4 border-[#a8dadc]/30 transform hover:scale-105 transition-transform">
            <ImageWithFallback
              src="https://images.unsplash.com/photo-1604890532358-4029426b27af?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoYXBweSUyMGNhcHliYXJhfGVufDF8fHx8MTc3NDk2MTY4MXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral"
              alt="Capybara with water bottle"
              className="w-full h-full object-cover"
            />
          </div>

          {/* Message */}
          <div className="text-center mb-6">
            <div className="flex items-center justify-center gap-2 mb-4">
              <Droplet className="w-8 h-8 text-[#a8dadc] fill-[#a8dadc] animate-bounce" />
              <h2 className="text-2xl text-[#bc6c25]">Hey there!</h2>
              <Droplet className="w-8 h-8 text-[#a8dadc] fill-[#a8dadc] animate-bounce" style={{ animationDelay: '0.2s' }} />
            </div>
            <p className="text-xl text-[#8b7355] mb-2">
              Your capybara says:
            </p>
            <p className="text-2xl text-[#457b9d] mb-1">
              Drink water 💙
            </p>
            <p className="text-sm text-[#8b7355]/70 italic">
              Stay hydrated, friend! 🐾
            </p>
          </div>

          {/* Action buttons */}
          <div className="space-y-3">
            <button
              onClick={handleDrank}
              className="w-full bg-gradient-to-r from-[#a8dadc] to-[#457b9d] text-white text-lg py-4 rounded-full shadow-lg hover:shadow-xl transform hover:scale-105 transition-all flex items-center justify-center gap-2"
            >
              <Droplet className="w-5 h-5 fill-white" />
              I drank!
            </button>
            
            <button
              onClick={handleSnooze}
              className="w-full bg-white/80 text-[#8b7355] text-lg py-4 rounded-full shadow-md hover:shadow-lg transform hover:scale-105 transition-all border-2 border-[#d6ccc2] flex items-center justify-center gap-2"
            >
              <Clock className="w-5 h-5" />
              Snooze (15 min)
            </button>
          </div>

          {/* Decorative elements */}
          <div className="flex justify-center gap-2 mt-6">
            <div className="w-2 h-2 rounded-full bg-[#a8dadc] animate-bounce" style={{ animationDelay: '0s' }}></div>
            <div className="w-2 h-2 rounded-full bg-[#a8dadc] animate-bounce" style={{ animationDelay: '0.2s' }}></div>
            <div className="w-2 h-2 rounded-full bg-[#a8dadc] animate-bounce" style={{ animationDelay: '0.4s' }}></div>
          </div>
        </div>

        {/* Floating water drops */}
        <div className="absolute -top-4 -right-4 w-12 h-12 rounded-full bg-[#a8dadc]/40 blur-sm animate-pulse"></div>
        <div className="absolute -bottom-4 -left-4 w-16 h-16 rounded-full bg-[#457b9d]/30 blur-md animate-pulse" style={{ animationDelay: '0.5s' }}></div>
      </div>
    </div>
  );
}
