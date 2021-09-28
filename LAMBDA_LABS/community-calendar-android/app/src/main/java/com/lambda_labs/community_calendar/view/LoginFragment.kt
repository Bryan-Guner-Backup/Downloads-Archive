package com.lambda_labs.community_calendar.view

import android.app.Dialog
import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.auth0.android.Auth0
import com.auth0.android.Auth0Exception
import com.auth0.android.authentication.AuthenticationException
import com.auth0.android.provider.AuthCallback
import com.auth0.android.provider.VoidCallback
import com.auth0.android.provider.WebAuthProvider
import com.auth0.android.result.Credentials
import com.lambda_labs.community_calendar.R
import com.lambda_labs.community_calendar.viewmodel.LoginViewModel
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.fragment_login.*
import org.koin.androidx.viewmodel.ext.android.viewModel


class LoginFragment : Fragment() {

    lateinit var auth0: Auth0
    lateinit var mainActivity: MainActivity
    private val viewModel: LoginViewModel by viewModel()

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mainActivity = context as MainActivity
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        auth0 = Auth0(mainActivity)
        auth0.isOIDCConformant = true


        if (viewModel.getToken() == null) {
//        Take user to login page when login or profile button is selected
            WebAuthProvider.login(auth0)
                .withScheme("demo")
                .withAudience(getString(R.string.audience))
                .start(mainActivity, object : AuthCallback {
                    override fun onSuccess(credentials: Credentials) {

//                    Save and store user token when user logs in
                        viewModel.saveToken(credentials.accessToken)

//                    upon successful login "Log In" nav button changes to the "Profile" button label
                        mainActivity.runOnUiThread {
                            val item =
                                mainActivity.bottom_navigation.menu.findItem(R.id.loginFragment)
                            item.title = getString(R.string.profile)
                        }
                    }

                    override fun onFailure(dialog: Dialog) {
                        println("Fail Dialog")
                    }

                    override fun onFailure(exception: AuthenticationException?) {
                        println(exception?.message)
                    }
                })
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

//        logout user when
        logout.setOnClickListener {
            // This will clear the token when the user logs out
            viewModel.saveToken(null)

            WebAuthProvider.logout(auth0)
                .withScheme("demo")
                .start(mainActivity, object : VoidCallback {
                    override fun onSuccess(payload: Void?) {

                        println("logged out")

//                    upon successful logout "Profile" nav button changes to the "Log In" button label
                        mainActivity.runOnUiThread {
                            val item =
                                mainActivity.bottom_navigation.menu.findItem(R.id.loginFragment)
                            item.title = getString(R.string.login)
                        }
                    }

                    override fun onFailure(error: Auth0Exception?) {
                        println("logout error")
                    }
                })
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_login, container, false)
    }
}
