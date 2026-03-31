import { useState } from "react";
import { useNavigate } from "react-router";
import { ImageWithFallback } from "./figma/ImageWithFallback";
import { ArrowLeft, Droplet, Trophy, Calendar } from "lucide-react";

export function ProgressScreen() {
  const navigate = useNavigate();
  const [waterCount] = useState(2);
  const totalGoal = 4;
  const progressPercentage = (waterCount / totalGoal) * 100;

  // Mock weekly data
  const weeklyData = [
    { day: "Mon", completed: 4, goal: 4 },
    { day: "Tue", completed: 3, goal: 4 },
    { day: "Wed", completed: 4, goal: 4 },
    { day: "Thu", completed: 2, goal: 4 },
    { day: "Fri", completed: 4, goal: 4 },
    { day: "Sat", completed: 3, goal: 4 },
    { day: "Sun", completed: 2, goal: 4 },
  ];

  return (
    <div className="min-h-screen w-full max-w-md mx-auto flex flex-col bg-gradient-to-b from-[#f5ebe0] to-[#e3d5ca] overflow-y-auto pb-8">
      {/* Header */}
      <div className="flex items-center p-6 z-10">
        <button
          onClick={() => navigate("/home")}
          className="p-3 rounded-full bg-white/70 shadow-md hover:bg-white/90 transition-all"
        >
          <ArrowLeft className="w-5 h-5 text-[#bc6c25]" />
        </button>
        <h1 className="flex-1 text-2xl text-[#bc6c25] text-center mr-12">
          Your Progress
        </h1>
      </div>

      {/* Decorative elements */}
      <div className="absolute top-20 right-5 w-28 h-28 rounded-full bg-[#a8dadc] opacity-20 blur-2xl"></div>
      <div className="absolute bottom-40 left-5 w-32 h-32 rounded-full bg-[#dda15e] opacity-15 blur-2xl"></div>

      <div className="px-6 space-y-6 z-10">
        {/* Capybara mood based on progress */}
        <div className="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-lg text-center">
          <div className="w-40 h-40 mx-auto mb-4 rounded-full overflow-hidden shadow-xl border-4 border-white/60">
            <ImageWithFallback
              src="https://images.unsplash.com/photo-1759963248344-8bf5f9c220fb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjYXB5YmFyYSUyMHN3aW1taW5nJTIwd2F0ZXJ8ZW58MXx8fHwxNzc0OTYxNjgxfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral"
              alt="Happy capybara"
              className="w-full h-full object-cover"
            />
          </div>
          <h2 className="text-2xl text-[#bc6c25] mb-2">
            {progressPercentage >= 100
              ? "Amazing! 🎉"
              : progressPercentage >= 75
              ? "You're doing great! 💪"
              : progressPercentage >= 50
              ? "Keep going! 😊"
              : "Let's hydrate! 💧"}
          </h2>
          <p className="text-[#8b7355]">
            Your capybara is {progressPercentage >= 75 ? "super happy" : "cheering for you"}!
          </p>
        </div>

        {/* Today's progress */}
        <div className="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-lg">
          <div className="flex items-center gap-2 mb-4">
            <Calendar className="w-5 h-5 text-[#457b9d]" />
            <h3 className="text-lg text-[#8b7355]">Today's Progress</h3>
          </div>
          
          {/* Progress bar */}
          <div className="mb-4">
            <div className="flex justify-between text-sm text-[#8b7355] mb-2">
              <span>{waterCount} bottles</span>
              <span>{totalGoal} bottles goal</span>
            </div>
            <div className="h-8 bg-[#d6ccc2]/50 rounded-full overflow-hidden shadow-inner">
              <div
                className="h-full bg-gradient-to-r from-[#a8dadc] to-[#457b9d] rounded-full transition-all duration-500 flex items-center justify-end pr-2"
                style={{ width: `${Math.min(progressPercentage, 100)}%` }}
              >
                {progressPercentage > 20 && (
                  <Droplet className="w-5 h-5 text-white fill-white" />
                )}
              </div>
            </div>
          </div>

          <div className="text-center">
            <span className="text-4xl text-[#bc6c25]">{Math.round(progressPercentage)}%</span>
            <p className="text-sm text-[#8b7355] mt-1">completed</p>
          </div>
        </div>

        {/* Weekly overview */}
        <div className="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-lg">
          <div className="flex items-center gap-2 mb-4">
            <Trophy className="w-5 h-5 text-[#f4a261]" />
            <h3 className="text-lg text-[#8b7355]">This Week</h3>
          </div>

          <div className="flex justify-between items-end h-40 mb-4">
            {weeklyData.map((data, index) => {
              const dayProgress = (data.completed / data.goal) * 100;
              return (
                <div key={index} className="flex flex-col items-center gap-2 flex-1">
                  <div className="relative w-full flex items-end justify-center h-32">
                    <div
                      className={`w-8 rounded-t-lg transition-all ${
                        dayProgress === 100
                          ? "bg-gradient-to-t from-[#a8dadc] to-[#457b9d]"
                          : dayProgress >= 75
                          ? "bg-gradient-to-t from-[#a8dadc] to-[#a8dadc]/60"
                          : "bg-[#d6ccc2]"
                      }`}
                      style={{ height: `${dayProgress}%` }}
                    >
                      {dayProgress === 100 && (
                        <div className="absolute -top-6 left-1/2 -translate-x-1/2">
                          <div className="text-lg">✨</div>
                        </div>
                      )}
                    </div>
                  </div>
                  <span className="text-xs text-[#8b7355]">{data.day}</span>
                </div>
              );
            })}
          </div>

          <div className="grid grid-cols-2 gap-4 pt-4 border-t-2 border-[#d6ccc2]/50">
            <div className="text-center">
              <p className="text-2xl text-[#bc6c25]">5</p>
              <p className="text-xs text-[#8b7355]">Days completed</p>
            </div>
            <div className="text-center">
              <p className="text-2xl text-[#bc6c25]">22</p>
              <p className="text-xs text-[#8b7355]">Total bottles</p>
            </div>
          </div>
        </div>

        {/* Motivational message */}
        <div className="bg-gradient-to-r from-[#a8dadc]/30 to-[#457b9d]/30 backdrop-blur-sm rounded-3xl p-6 text-center">
          <p className="text-lg text-[#8b7355] italic">
            "Keep up the great work! Your body thanks you!" 💙
          </p>
          <p className="text-sm text-[#8b7355]/70 mt-2">- Your caring capybara</p>
        </div>
      </div>
    </div>
  );
}
