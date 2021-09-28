import React, { useEffect } from "react";
import getLogo from "../../utils/getLogo";
import { getTeamsDB } from "../../Redux/actions/index";
import { connect } from "react-redux";
import { postFavoriteTeam } from "../../Redux/actions/index";
import { postFollowingTeam } from "../../Redux/actions/index";
import { getFollowingTeams } from "../../Redux/actions/index";
import { Link } from "react-router-dom";

const TeamList = props => {
  useEffect(() => {
    props.getTeamsDB();
  }, [props]);

  useEffect(() => {
    props.getFollowingTeams(props.profile_id)
  }, [props])

 

  console.log("following", props.following)
  
  const submit = team => {
    const teams = {
      profile_id: props.profile_id,
      team_id: team.team_id,
      abbreviation: team.abbreviation,      
    };     
      props.postFollowingTeam(teams)
    }     
                 
  


  return (
    <div style={{ paddingTop: 70, margin: "auto", maxWidth: 1000 }}>
      <h1 style={{ textAlign: "center" }}>
        Pick Your Favorite Teams To Follow
      </h1>
      <div style={{ textAlign: "center" }}>
        {props.teams.map(team => { 
          return (
            <button
              onClick={() => submit(team)}
              style={{ margin: 20 }}
              key={team.abbreviation}
              className="cy-teams"
            >
              <Link to="/profile">
                <img src={getLogo(team.abbreviation)} width="100px" />
              </Link>
            </button>
          );
        })}})
      </div>      
    </div>
  );
};

const mapStateToProps = state => {
  return {
    profile_id: state.profile_id,
    favorite: state.favoriteTeams,
    profile: state.profile,
    username: state.username,
    teams: state.teams,
    following: state.followingTeams
  };
};

export default connect(
  mapStateToProps,
  { postFavoriteTeam, getTeamsDB, postFollowingTeam, getFollowingTeams  }
)(TeamList);
