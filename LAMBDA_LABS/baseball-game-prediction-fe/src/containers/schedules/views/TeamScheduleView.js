import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import GameCard from "../components/GameCard";
import Grid from "@material-ui/core/Grid";
import { Typography, CircularProgress } from "@material-ui/core";
import MomentUtils from "@date-io/moment";
import {
  MuiPickersUtilsProvider,
  KeyboardDatePicker
} from "@material-ui/pickers";
import moment from "moment";
import { connect } from "react-redux";
import { fetchCurrentTeamSchedule } from "../../../Redux/actions/index";
import { makeStyles } from "@material-ui/core/styles";

//CSS
import "../../../App.css";
import { width } from "dom-helpers";

const useStyles = makeStyles(theme => ({
  link: {
    textDecoration: "underline",
    color: "black"
  },
  circleProgress: {
    display: "flex",
    "& > * + *": {
      marginLeft: theme.spacing(2)
    }
  },
  tsvContainer: {
    maxWidth: "800px",
    width: "100%",
    margin: "auto",
    justifyContent: "center"
  }
}));

const TeamScheduleView = props => {
  const [games, setGames] = useState([]);
  const [startDate, setStartDate] = useState("20190721");
  const [endDate, setEndDate] = useState("20190728");
  const classes = useStyles();

  useEffect(() => {
    props.fetchCurrentTeamSchedule(
      props.match.params.team_id,
      startDate,
      endDate
    );
  }, [startDate, endDate]);

  useEffect(() => {
    const gamesContainer = props.teamscheduleData.map(game => {
      return (
        <Grid
          item
          xs={10}
          sm={12}
          style={{ paddingBottom: 12 }}
          key={game.schedule.id}
        >
          <Link
            to={`/gamedata/${moment(game.schedule.startTime).format(
              "YYYYMMDD"
            )}/${game.schedule.awayTeam.abbreviation}/${
              game.schedule.homeTeam.abbreviation
            }`}
          >
            <GameCard
              away_team={game.schedule.awayTeam.abbreviation}
              home_team={game.schedule.homeTeam.abbreviation}
              away_score={game.score.awayScoreTotal}
              home_score={game.score.homeScoreTotal}
              date={moment(game.schedule.startTime).format("LLL")}
            />
          </Link>
        </Grid>
      );
    });
    setGames(gamesContainer);
  }, [props.teamscheduleData]);

  const handleStartDateChange = newDate => {
    const newStartDate = moment(newDate._d).format("YYYYMMDD");
    setStartDate(newStartDate);
  };

  const handleEndDateChange = newDate => {
    const newEndDate = moment(newDate._d).format("YYYYMMDD");
    setEndDate(newEndDate);
  };

  return (
    <div className={classes.tsvContainer}>
      <div
        className="datepicker-container"
        style={{ marginTop: "62px", backgroundColor: "lightgrey", padding: 15 }}
      >
        <MuiPickersUtilsProvider utils={MomentUtils}>
          <Grid container justify="space-around">
            <KeyboardDatePicker
              disableToolbar
              variant="inline"
              format="MM/DD/YYYY"
              margin="normal"
              id="start-date-picker-inline"
              label="Start Date"
              value={startDate}
              onChange={handleStartDateChange}
              KeyboardButtonProps={{
                "aria-label": "change start date"
              }}
            />
          </Grid>
        </MuiPickersUtilsProvider>
        <MuiPickersUtilsProvider utils={MomentUtils}>
          <Grid container justify="space-around">
            <KeyboardDatePicker
              disableToolbar
              variant="inline"
              format="MM/DD/YYYY"
              margin="normal"
              id="end-date-picker-inline"
              label="End Date"
              value={endDate}
              onChange={handleEndDateChange}
              KeyboardButtonProps={{
                "aria-label": "change end date"
              }}
            />
          </Grid>
        </MuiPickersUtilsProvider>
      </div>

      <Grid
        container
        justify="center"
        style={{ margin: "75px auto auto", maxWidth: 500 }}
      >
        {props.teamscheduledataLoading ? (
          <div className={classes.circleProgress}>
            <CircularProgress
              size={50}
              thickness={2}
              style={{ margin: "75px auto", color: "white" }}
            />
          </div>
        ) : props.teamscheduleError ? (
          <Typography>
            There was an issue loading the schedule. Please try again later .
          </Typography>
        ) : (
          <Grid container justify="center" style={{ margin: "20px auto auto" }}>
            {games}
          </Grid>
        )}
      </Grid>
    </div>
  );
};

const mapStateToProps = state => {
  return {
    teams: state.teams,
    teamscheduledataLoading: state.teamscheduledataLoading,
    teamscheduleData: state.teamscheduleData,
    teamscheduleError: state.teamscheduleError
  };
};

export default connect(
  mapStateToProps,
  { fetchCurrentTeamSchedule }
)(TeamScheduleView);
