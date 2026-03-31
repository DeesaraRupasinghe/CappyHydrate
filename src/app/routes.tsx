import { createBrowserRouter } from "react-router";
import { SplashScreen } from "./components/SplashScreen";
import { HomeScreen } from "./components/HomeScreen";
import { SetupScreen } from "./components/SetupScreen";
import { ProgressScreen } from "./components/ProgressScreen";
import { ReminderAlert } from "./components/ReminderAlert";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: SplashScreen,
  },
  {
    path: "/home",
    Component: HomeScreen,
  },
  {
    path: "/setup",
    Component: SetupScreen,
  },
  {
    path: "/progress",
    Component: ProgressScreen,
  },
  {
    path: "/reminder",
    Component: ReminderAlert,
  },
]);
