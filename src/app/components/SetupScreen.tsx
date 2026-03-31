import { useState } from "react";
import { useNavigate } from "react-router";
import { Droplet, Moon, Sun, ArrowRight } from "lucide-react";

export function SetupScreen() {
  const navigate = useNavigate();
  const [selectedBottles, setSelectedBottles] = useState(4);
  const [sleepStart, setSleepStart] = useState("22:00");
  const [sleepEnd, setSleepEnd] = useState("07:00");

  const handleComplete = () => {
    navigate("/home");
  };

  return (
    <div className="h-screen w-full max-w-md mx-auto flex flex-col bg-gradient-to-b from-[#f5ebe0] to-[#e3d5ca] overflow-y-auto">
      {/* Decorative elements */}
      <div className="absolute top-10 right-5 w-32 h-32 rounded-full bg-[#a8dadc] opacity-20 blur-2xl"></div>
      <div className="absolute bottom-20 left-5 w-28 h-28 rounded-full bg-[#dda15e] opacity-15 blur-2xl"></div>

      <div className="flex-1 p-8 z-10">
        {/* Header */}
        <div className="text-center mb-10 mt-8">
          <div className="w-20 h-20 mx-auto mb-4 rounded-full bg-gradient-to-br from-[#a8dadc] to-[#457b9d] flex items-center justify-center shadow-xl">
            <Droplet className="w-10 h-10 text-white fill-white" />
          </div>
          <h1 className="text-3xl text-[#bc6c25] mb-2">Set your daily water goal</h1>
          <p className="text-[#8b7355]">Help your capybara keep you hydrated!</p>
        </div>

        {/* Bottles selection */}
        <div className="bg-white/70 backdrop-blur-sm rounded-3xl p-6 shadow-lg mb-6">
          <h3 className="text-lg text-[#8b7355] mb-4 text-center">
            How many bottles per day?
          </h3>
          <div className="grid grid-cols-4 gap-3 mb-4">
            {Array.from({ length: 8 }, (_, i) => i + 1).map((num) => (
              <button
                key={num}
                onClick={() => setSelectedBottles(num)}
                className={`aspect-square rounded-2xl flex flex-col items-center justify-center transition-all ${
                  selectedBottles === num
                    ? "bg-gradient-to-br from-[#a8dadc] to-[#457b9d] text-white shadow-lg scale-110"
                    : "bg-white/80 text-[#8b7355] hover:bg-white"
                }`}
              >
                <Droplet
                  className={`w-6 h-6 mb-1 ${
                    selectedBottles === num ? "fill-white" : ""
                  }`}
                />
                <span className="text-sm">{num}</span>
              </button>
            ))}
          </div>
          <p className="text-sm text-[#8b7355] text-center">
            Selected: <span className="font-semibold">{selectedBottles} bottles</span>
          </p>
        </div>

        {/* Sleep time selector */}
        <div className="bg-white/70 backdrop-blur-sm rounded-3xl p-6 shadow-lg mb-6">
          <h3 className="text-lg text-[#8b7355] mb-4 text-center">
            When do you sleep?
          </h3>
          
          <div className="space-y-4">
            {/* Sleep start */}
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#457b9d] to-[#1d3557] flex items-center justify-center shadow-md">
                <Moon className="w-6 h-6 text-white" />
              </div>
              <div className="flex-1">
                <label className="text-sm text-[#8b7355] block mb-1">
                  Bedtime
                </label>
                <input
                  type="time"
                  value={sleepStart}
                  onChange={(e) => setSleepStart(e.target.value)}
                  className="w-full px-4 py-2 rounded-xl border-2 border-[#d6ccc2] focus:border-[#a8dadc] focus:outline-none bg-white/80 text-[#8b7355]"
                />
              </div>
            </div>

            {/* Sleep end */}
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#f4a261] to-[#e76f51] flex items-center justify-center shadow-md">
                <Sun className="w-6 h-6 text-white" />
              </div>
              <div className="flex-1">
                <label className="text-sm text-[#8b7355] block mb-1">
                  Wake up time
                </label>
                <input
                  type="time"
                  value={sleepEnd}
                  onChange={(e) => setSleepEnd(e.target.value)}
                  className="w-full px-4 py-2 rounded-xl border-2 border-[#d6ccc2] focus:border-[#a8dadc] focus:outline-none bg-white/80 text-[#8b7355]"
                />
              </div>
            </div>
          </div>

          <div className="mt-4 p-4 bg-[#a8dadc]/20 rounded-2xl">
            <p className="text-sm text-[#8b7355] text-center">
              💙 We'll remind you at the best times
            </p>
          </div>
        </div>

        {/* Continue button */}
        <button
          onClick={handleComplete}
          className="w-full bg-gradient-to-r from-[#a8dadc] to-[#457b9d] text-white text-xl py-5 rounded-full shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all flex items-center justify-center gap-2"
        >
          Let's Start!
          <ArrowRight className="w-6 h-6" />
        </button>
      </div>
    </div>
  );
}
